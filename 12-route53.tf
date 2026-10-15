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
# API
# ------------------------------------------------------------
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "api.wecnedu.com"
  type    = "CNAME"
  ttl     = 300

  records = [
    "k8s-msa-public-5999b13c4f-188025152.ap-northeast-2.elb.amazonaws.com"
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
    "k8s-msa-public-5999b13c4f-188025152.ap-northeast-2.elb.amazonaws.com"
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
    "a2e2df5a4864e4e8bbe849ebf9ad353e-918311987.ap-northeast-2.elb.amazonaws.com"
  ]
}