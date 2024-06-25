resource "aws_key_pair" "bastion" {
  key_name   = "${var.environment}-wp-bastion"
  public_key = var.public_key_bastion
}

module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name = "${var.environment}-bastion"

  instance_type               = "t3.micro"
  ami                         = var.wordpress_ami
  key_name                    = aws_key_pair.bastion.key_name
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.bastion-sg.security_group_id]
  associate_public_ip_address = true

  tags = local.tags
}