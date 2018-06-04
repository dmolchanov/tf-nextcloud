output "images" {
  value = "${lookup(var.images, var.region)}"
}
output "ip" {
  value = "${aws_eip.ip.public_ip}"
}
