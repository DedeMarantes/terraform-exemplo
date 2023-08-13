data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
//instancia na subrede publica
resource "aws_instance" "public_instance" {
  depends_on = [ aws_efs_file_system.efs-teste ]
  ami             = data.aws_ami.amazon-linux.id
  subnet_id       = aws_subnet.public_subnet.id
  instance_type   = var.instance-type
  security_groups = ["${aws_security_group.acessos.id}"]
  key_name        = data.aws_key_pair.key-pair.key_name
  tags = {
    "Subrede" = "Instancia na subrede certa",
    "Name"    = "instancia exemplo"
  }
  //script para montar efs
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install amazon-efs-utils -y
sudo mkdir /mnt/efs
sudo mount.efs ${aws_efs_file_system.efs-teste.id} /mnt/efs
EOF
}


//Instancia subrede privada
resource "aws_instance" "my_instance" {
  ami             = data.aws_ami.amazon-linux.id
  subnet_id       = aws_subnet.private_subnet.id
  instance_type   = var.instance-type
  security_groups = ["${aws_security_group.acessos.id}"]
  key_name        = data.aws_key_pair.key-pair.key_name
  tags = {
    "Subrede" = "Instancia na subrede privada certa",
    "Name"    = "instancia subrede privada exemplo"
  }
}

//Chave publica
data "aws_key_pair" "key-pair" {
  key_name = "aws-key"
}
