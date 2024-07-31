resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags={
        Name="cust_vpc"
    }
}


#create IG and attach to VPC

resource "aws_internet_gateway" "dev" {

   vpc_id = aws_vpc.dev.id
   tags = {
     Name = "cust_ig"
   } 

}

#create public subnet

resource "aws_subnet" "dev" {
   vpc_id = aws_vpc.dev.id
   cidr_block = "10.0.0.0/24"
   availability_zone = "ap-southeast-1a"
   map_public_ip_on_launch = true
   tags = {
    Name ="cust_subnet_pub"
   }
}


#Create Route table

resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
        Name = "cust_pub_rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev.id

    }
}

resource "aws_route_table_association" "dev" {
    subnet_id = aws_subnet.dev.id
    route_table_id = aws_route_table.dev.id
}

resource "aws_security_group" "dev" {
    vpc_id = aws_vpc.dev.id
    name   = "allow traffic"
    description = "Allow TLS inbound traffic and all outbound traffic"
    tags = {
        Name = "cust_dev_s"
    }
    ingress {
        description = "TLS from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "TLS from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "TLS from VPC"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "dev" {
    ami="ami-012c2e8e24e2ae21d"
    instance_type = "t2.micro"
    key_name = "Terraform-keypair"
    vpc_security_group_ids = [aws_security_group.dev.id]
    associate_public_ip_address = true
    subnet_id = aws_subnet.dev.id
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "dev-2"
    }
}

resource "aws_s3_bucket" "test" {
    bucket = "my-cust-bucket"
  
}
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}





