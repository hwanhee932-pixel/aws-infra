# ============================================================
# Route53
# api.wecnedu.com
# www.wecnedu.com
# grafana.wecnedu.com
# ============================================================

data "aws_route53_zone" "main" {
  zone_id = "Z0922210QC4AYNQLD8G1"
}

# ------------------------------------------------------------
# Current Kubernetes Public ALB
# ------------------------------------------------------------
locals {
  public_alb_dns = "k8s-msaplatformpublic-5d442f2ac3-987232936.ap-northeast-2.elb.amazonaws.com"
}

# ------------------------------------------------------------
# API
# ------------------------------------------------------------
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "api.wecnedu.com"
  type    = "CNAME"
  ttl     = 300

  records = [
    local.public_alb_dns
  ]
}

# ------------------------------------------------------------
# Frontend
# ------------------------------------------------------------
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.wecnedu.com"
  type    = "CNAME"
  ttl     = 300

  records = [
    local.public_alb_dns
  ]
}

# ------------------------------------------------------------
# Grafana
# ------------------------------------------------------------
resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "grafana.wecnedu.com"
  type    = "CNAME"
  ttl     = 300

  records = [
    local.public_alb_dns
  ]
}