output "aws_lb_id" {
  value = aws_lb.main.id
}
output "aws_lb_arn" {
  value = aws_lb.main.arn
}
output "aws_lb_dns" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.main.dns_name, "")
}
output "aws_alb_target_group_id" {
  value = aws_alb_target_group.main.id
}
output "target_group_arn" {
  value = aws_alb_target_group.main.arn
}
