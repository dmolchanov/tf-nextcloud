provider "aws" {
  region     = "${var.region}"
}

resource "aws_security_group" "nextcloud_sg" {
  name = "nextcloud_sg"
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow outbound traffic"
    from_port = 0
    to_port = 0
    protocol = -1
  }
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow http"
    protocol = "tcp"
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 80
    to_port = 80
  }
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow https"
    protocol = "tcp"
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 443
    to_port = 443
  }
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow ssh"
    protocol = "tcp"
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 22
    to_port = 22
  }
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow mysql"
    protocol = "tcp"
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 3306
    to_port = 3306
  }
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow icmp"
    protocol = "icmp"
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 0
    to_port = 0
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "example" {
  ami           = "${lookup(var.images, var.region)}"
  instance_type = "t2.micro"
  key_name      = "main"
  depends_on    = [ "aws_key_pair.main", "aws_db_instance.nextcloud_db", "aws_s3_bucket.ncbucket", "data.template_file.nextcloud_config" ]
  security_groups = [ "${aws_security_group.nextcloud_sg.name}" ]
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
    }
    content = "${data.template_file.nextcloud_config.rendered}"
    destination = "/home/ec2-user/config.php.nc"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
    }
    inline = [
      "sudo mv /home/ec2-user/config.php.nc /var/www/nextcloud/config/config.php",
      "sudo chown apache /var/www/nextcloud/config/config.php",
      "sudo chmod 640 /var/www/nextcloud/config/config.php"
    ]
  }
}

resource "aws_db_instance" "nextcloud_db" {
  allocated_storage = 20
  storage_type = "standard"
  engine = "mysql"
  engine_version = "5.7"
  name = "${var.nextcloud_db_name}"
  username = "${var.nextcloud_db_user}"
  password = "${var.nextcloud_db_password}"
  instance_class = "db.t2.micro"
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
  provisioner "local-exec" {
    command = "echo ${aws_eip.ip.public_ip} > ip_address.txt"
  }
}

resource "aws_s3_bucket" "ncbucket" {
  #bucket = "${var.nextcloud_s3_bucket_id}_tst-ncloud-bucket"
  bucket = "tst-ncloud-bucket"
  acl = "private"
}

resource "aws_key_pair" "main" {
  key_name = "main"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKOpth02JViWVVc+keJlUzV3As1onPlDbWzmz8FAKq3TuyWUrtJL7KaoAmDX/cOPwwCdgXABXLriCFrqGF49sEccxBNFTzDy71rzGi9Kqsk78XdFNIVI41ZhLfZUtV0we8zw/yFEXat64zilIkT1iXi8gJ7smPgilb0uqIAdwLj43Y5cq0InYiryQl/SnkO9j6zehs5qB+KSN/916Ok9GqNcCAZ+sWKhU8CCeDNXvM2nHMpY4OSas14cWbkocUyfjfrZaO1VmAceXPWeNJtOPS849FHhMCGWGj+ceeh1VkgW6q42XAa7xronueNaIDhU8UoRLgccNGF6AGPG+2pPvD dmolchanov@MacBook-Pro-Dmitry.local" 
}

data "template_file" "nextcloud_config" {
  template = "${file("files/config.php")}"
  vars { 
    db_user = "${aws_db_instance.nextcloud_db.username}"
    db_address = "${aws_db_instance.nextcloud_db.address}"
    db_port = "${aws_db_instance.nextcloud_db.port}"
    db_password = "${aws_db_instance.nextcloud_db.password}"
    s3_bucket = "${aws_s3_bucket.ncbucket.id}"
    s3_domain = "${replace("${aws_s3_bucket.ncbucket.bucket_domain_name}","${aws_s3_bucket.ncbucket.id}.","")}" 
    aws_secret = "${var.secret_key}"
    aws_access = "${var.access_key}"
#    aws_eip = "${aws_eip.ip.public_ip}"
    aws_region = "${var.region}"
  }
}
