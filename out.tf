output "elb_dns_name" {
  value = "${aws_elb.nc_lb.dns_name}"
}
