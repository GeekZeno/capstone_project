# Create a hosted zone
resource "aws_route53_zone" "upgrad" {
  name = "upgrad.com"
}

# Primary health check for AWS app EC2 instance
resource "aws_route53_health_check" "aws_app_http" {
  ip_address        = aws_instance.app.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  request_interval  = 30
  failure_threshold = 2

  tags = {
    Name = "aws-app-health"
  }
}

# Secondary health check for Azure VM (you will provide its public IP)
#variable "azure_public_ip" {
#  description = "Public IP of the Azure VM for failover"
#  type        = string
#}

#resource "aws_route53_health_check" "azure_app_http" {
#  ip_address        = var.azure_public_ip
#  port              = 80
#  type              = "HTTP"
#  resource_path     = "/"
#  request_interval  = 30
#  failure_threshold = 2
#
#  tags = {
#    Name = "azure-app-health"
#  }
# }

# Primary Route53 record (AWS)
resource "aws_route53_record" "primary_app" {
  zone_id = aws_route53_zone.upgrad.zone_id
  name    = "app.upgrad.com"
  type    = "A"
  set_identifier = "aws-primary"
  ttl     = 60

  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.aws_app_http.id
  records = [aws_instance.app.public_ip]
}

# Secondary Route53 record (Azure)
# resource "aws_route53_record" "secondary_app" {
 # zone_id = aws_route53_zone.upgrad.zone_id
 # name    = "app.upgrad.com"
 # type    = "A"
 # set_identifier = "azure-secondary"
 # ttl     = 60
#
 # failover_routing_policy {
  #  type = "SECONDARY"
 # }

  #health_check_id = aws_route53_health_check.azure_app_http.id
#  records = [var.azure_public_ip]
# }
