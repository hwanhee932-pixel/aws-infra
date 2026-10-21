# ============================================================
# Route53
# api.wecnedu.com
# www.wecnedu.com
# grafana.wecnedu.com
# ============================================================

data "aws_route53_zone" "main" {
  zone_id = "Z01196761PGIK78VV8UBP"
}

# ------------------------------------------------------------
# Current Kubernetes Public ALB
# ------------------------------------------------------------
locals {
  public_alb_dns = " k8s-ingressn-ingressn-7791990f4f-4f346a245a40be30.elb.ap-northeast-2.amazonaws.com"
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
