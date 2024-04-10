######################################
## AWS ECS
######################################
# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    Terraform   = "Yes"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/ecs/${var.cluster_name}-task"
  retention_in_days = var.logs_retention_in_days
  tags = {
    Name        = "${var.cluster_name}-task"
    Environment = var.environment
  }
}

############ Service Task Definition ###########################
resource "aws_iam_role" "iam_role" {
  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  container_definitions = jsonencode([
    {
      name : var.app_name,
      image : "${var.ecr_repository_url}:latest",
      essential : true,
      cpu : var.fargate_cpu,
      memory : var.fargate_memory,
      networkMode : "awsvpc",
      logConfiguration : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.cloudwatch_log_group.name
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs-logs"
        }
      },
      portMappings : [
        {
          "protocol" : "tcp"
          "containerPort" : var.app_port,
          "hostPort" : var.app_port,
        }
      ],
    }
  ])
  cpu                      = var.fargate_cpu
  execution_role_arn       = aws_iam_role.iam_role.arn
  family                   = var.family
  memory                   = var.fargate_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  depends_on = [
    aws_ecs_cluster.ecs_cluster,
  ]

  tags = {
    Name        = "${var.cluster_name}-ecstask"
    Environment = var.environment
  }
}

# ECS API Service
resource "aws_ecs_service" "ecs_service" {
  name                               = var.ecs_service_name
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  desired_count                      = 1
  enable_ecs_managed_tags            = false
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  scheduling_strategy                = "REPLICA"
  task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn

  load_balancer {
    container_name   = var.app_name
    container_port   = var.app_port
    target_group_arn = var.target_group_arn
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = var.security_group_ids
    subnets          = var.private_subnet_ids
  }

  depends_on = [
    aws_ecs_cluster.ecs_cluster,
    aws_ecs_task_definition.ecs_task_definition
  ]

  tags = {
    Name        = "${var.cluster_name}-ecs-service"
    Environment = var.environment
    Terraform   = "Yes"
  }
}

# ECS AutoScaling
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
