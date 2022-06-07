resource "aws_instance" "bashionHost" {
    ami                    = lookup(var.AMIS, var.region)
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.key_pair.key_name
    subnet_id              = module.vpc.public_subnets[0]
    count                  = var.instance_count
    vpc_security_group_ids = [aws_security_group.bashionhost-sg-vprofile]

    tags = {
      Name    = "vprofile-bastion"
      PROJECT = "vprofile"
    }

    provisioner "file" {
      content     = templatefile("templates/db-deploy.tmpl", { rds-endpoint = aws_db_instance.vprofile_mysql.address, dbuser = var.dbuser, dbpass = var.dbpass })
      destination = "/tmp/vprofile-dbdeploy.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/vprofile-dbdeploy.sh",
        "sudo /tmp/vprofile-dbdeploy.sh"
      ]
    }
    connection {
      user        = var.user
      private_key = file(var.private_key)
      host        = self.public_ip
    }
    depends_on = [aws_db_instance.vprofile_mysql]
  }