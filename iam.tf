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
//Criar grupo segurança para acesso a efs,ssh e http
resource "aws_security_group" "acessos" {
  name   = "acessos ssh,efs e http"
  vpc_id = aws_vpc.vpc-criada.id
  dynamic "ingress" {
    for_each = var.settings
    iterator = acessos_ingress
    content {
      description = acessos_ingress.value["description"]
      from_port   = acessos_ingress.value["port"]
      to_port = acessos_ingress.value["port"]
      protocol = "tcp"
      cidr_blocks = [aws.aws_vpc.vpc-criada.cidr_block]
    }
  }
}