// Update beta.correcthorsebatterystaple.com CNAME


variable "dnsimple_token" {

}

variable "dnsimple_account" {

}

provider "dnsimple" {
  token = var.dnsimple_token
  account = var.dnsimple_account
}

// update record
resource "dnsimple_record" "beta_chs" {
  domain = "correcthorsebatterystaple.com"
  name = "beta"
  type = "CNAME"
  ttl = "60"
  priority = "0"
  value = aws_lb.lb.dns_name
}