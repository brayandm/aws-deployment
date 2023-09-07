resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("./ssh/terraform.pub")
}

resource "aws_instance" "ec2" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name

  vpc_security_group_ids      = [aws_security_group.security_group.id]
  associate_public_ip_address = false
  monitoring             = true

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "Server"
  }
}