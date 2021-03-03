resource "aws_vpc" "bean" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.app_name
  }
}

resource "aws_default_security_group" "bean" {
  vpc_id = aws_vpc.bean.id

  tags = merge(
    {
      Name = "${var.app_name}-vpc",
    }
  )
}
