resource "aws_iam_user" "user" {
  name = "user"
}
resource "aws_iam_group" "admin-group" {
  name = "admin-group"
}
//Criar politica adminstrador
resource "aws_iam_policy" "admin-policy" {
  name   = "admin-policy"
  policy = file("admin-policy.json")
}
//colocar politica no grupo
resource "aws_iam_group_policy_attachment" "name" {
  group      = aws_iam_group.admin-group.name
  policy_arn = aws_iam_policy.admin-policy.arn
}
//colocar usuario no grupo
resource "aws_iam_group_membership" "group-membership" {
  name  = "users-admin"
  group = aws_iam_group.admin-group.name
  users = [
    aws_iam_user.user.name
  ]

}
//Criar grupo segurança para acesso a ssh e http
resource "aws_security_group" "acessos" {
  name   = "acessos ssh e http"
  vpc_id = aws_vpc.vpc-criada.id
  ingress {
    description = "acesso ssh"
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "acesso http"
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}