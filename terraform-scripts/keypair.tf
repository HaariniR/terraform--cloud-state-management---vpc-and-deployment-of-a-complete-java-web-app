resource "aws_key_pair" "key_pair" {
  key_name = "project_key"
  public_key = file(var.public_key)
}