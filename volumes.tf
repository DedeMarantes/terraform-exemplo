//Volume EFS
resource "aws_efs_file_system" "efs-teste" {
  creation_token = "efs-teste"
  tags = {
    Name = "efs-teste"
  }
}
//Criando Mount targets
resource "aws_efs_mount_target" "mounts" {
    depends_on = [ aws_efs_file_system.efs-teste ]
    file_system_id  = aws_efs_file_system.efs-teste.id
    subnet_id       = aws_subnet.public_subnet.id
    security_groups = ["${aws_security_group.acessos.id}"]
}

//Volumes ebs
resource "aws_ebs_volume" "ebs-teste" {
  availability_zone = var.zones[0] #us-east-1a
  size              = 10           #10GB de espaço
  type              = "gp2"
  tags = {
    Name = "ebs-teste"
  }
}

//Associação de volume com instancia
resource "aws_volume_attachment" "associacao_volume" {
  depends_on  = [aws_instance.public_instance]
  instance_id = aws_instance.public_instance.id
  volume_id   = aws_ebs_volume.ebs-teste.id
  device_name = "/dev/xvdf"
}
