output "app_public_ip" {
  description = "Public IP of App Machine"
  value       = aws_instance.app.public_ip
}

output "tools_public_ip" {
  description = "Public IP of Tools Machine"
  value       = aws_instance.tools.public_ip
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}

output "route53_zone" {
  value = aws_route53_zone.upgrad.name
}
