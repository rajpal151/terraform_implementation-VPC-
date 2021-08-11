terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.0"
        }
    }
}

#configure the AWS

provider "aws"  {
    region = "ap-south-1"
}

#Create our first VPC
resource "aws_vpc" "MyLab-VPC"{
    cidr_block = var.cidr_block[0]
    tags = {
        Name = "MyLab-VPC"
    }
}

#create subnet for VPC
resource "aws_subnet" "MyLab-Subnet" {
    vpc_id = aws_vpc.MyLab-VPC.id
    cidr_block = var.cidr_block[1]

    tags = {
        Name = "MyLab-Subnet"
    }
}

#create Internet Gateway
resource "aws_internet_gateway" "MyIGW" {
    vpc_id = aws_vpc.MyLab-VPC.id

    tags = {
        Name = "MyIGW"
    }
}

#create Security Group
resource "aws_security_group" "MyLab_Sec_Grp" {
    name = "MyLab Security Group"
    description = "To allow inbound and outbound traffic"
    vpc_id = aws_vpc.MyLab-VPC.id
    dynamic ingress{
        iterator = port
        for_each = var.ports                //fetching  ports from variables.tf
        content {
        from_port = port.value
        to_port = port.value 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
         
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Allow Traffic"
    }
    
}

# Create Route table and associate it with subnet 
resource "aws_route_table" "MyLab_RouteTable" {
    vpc_id = aws_vpc.MyLab-VPC.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.MyIGW.id
    }
    tags = {
        Name = "MyRouteTable"
}
}

#create association
resource "aws_route_table_association" "MyLab_Association" {
    subnet_id = aws_subnet.MyLab-Subnet.id
    route_table_id = aws_route_table.MyLab_RouteTable.id
}

# Create EC2 Instances
resource "aws_instance" "MyNewInstance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "workingKeyPair"
    vpc_security_group_ids = [aws_security_group.MyLab_Sec_Grp.id]
    subnet_id = aws_subnet.MyLab-Subnet.id
    associate_public_ip_address = true

    tags = {
        Name = "MyNewInstance"
    }

}
=======
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.0"
        }
    }
}

#configure the AWS

provider "aws"  {
    region = "ap-south-1"
}

#Create our first VPC
resource "aws_vpc" "MyLab-VPC"{
    cidr_block = var.cidr_block[0]
    tags = {
        Name = "MyLab-VPC"
    }
}

#create subnet for VPC
resource "aws_subnet" "MyLab-Subnet" {
    vpc_id = aws_vpc.MyLab-VPC.id
    cidr_block = var.cidr_block[1]

    tags = {
        Name = "MyLab-Subnet"
    }
}

#create Internet Gateway
resource "aws_internet_gateway" "MyIGW" {
    vpc_id = aws_vpc.MyLab-VPC.id

    tags = {
        Name = "MyIGW"
    }
}

#create Security Group
resource "aws_security_group" "MyLab_Sec_Grp" {
    name = "MyLab Security Group"
    description = "To allow inbound and outbound traffic"
    vpc_id = aws_vpc.MyLab-VPC.id
    dynamic ingress{
        iterator = port
        for_each = var.ports                //fetching  ports from variables.tf
        content {
        from_port = port.value
        to_port = port.value 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
         
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Allow Traffic"
    }
    
}

# Create Route table and associate it with subnet 
resource "aws_route_table" "MyLab_RouteTable" {
    vpc_id = aws_vpc.MyLab-VPC.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.MyIGW.id
    }
    tags = {
        Name = "MyRouteTable"
}
}

#create association
resource "aws_route_table_association" "MyLab_Association" {
    subnet_id = aws_subnet.MyLab-Subnet.id
    route_table_id = aws_route_table.MyLab_RouteTable.id
}

# Create EC2 Instances - Jenkins
resource "aws_instance" "Jenkins-Server" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "pemKeyPair"
    vpc_security_group_ids = [aws_security_group.MyLab_Sec_Grp.id]
    subnet_id = aws_subnet.MyLab-Subnet.id
    associate_public_ip_address = true
    user_data = file("./myScript.sh")

    tags = {
        Name = "Jenkins-Server"
    }

}

#create EC2 Instance - Ansible node 
resource "aws_instance" "AnsibleNode" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "pemKeyPair"
    vpc_security_group_ids = [aws_security_group.MyLab_Sec_Grp.id]
    subnet_id = aws_subnet.MyLab-Subnet.id
    associate_public_ip_address = true
    user_data = file("./ansibleScript.sh")

    tags = {
        Name = "Ansible-Node"
    }
}

#create EC2 Instance - Ansible Managed Node 1 for apache tomcat 
resource "aws_instance" "AnsibleMangedNode" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "pemKeyPair"
    vpc_security_group_ids = [aws_security_group.MyLab_Sec_Grp.id]
    subnet_id = aws_subnet.MyLab-Subnet.id
    associate_public_ip_address = true
    user_data = file("./ansibleMangedNode.sh")

    tags = {
        Name = "Ansible-Manged-Node"
    }

}

#Create EC2 Instance for Docker Manages by Ansible Nodes
resource "aws_instance" "Docker" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "pemKeyPair"
    vpc_security_group_ids = [aws_security_group.MyLab_Sec_Grp.id]
    subnet_id = aws_subnet.MyLab-Subnet.id
    associate_public_ip_address = true
    user_data = file("./docker.sh")

    tags = {
        Name = "Docker"

}
}
#Creating SonaType Nexus for Managing our repository which requires t2.medium
resource "aws_instance" "SonaType-Nexus" {
    ami = var.ami
    instance_type = var.instance_type_for_nexus
    key_name = "pemKeyPair"
    vpc_security_group_ids = [aws_security_group.MyLab_Sec_Grp.id]
    subnet_id = aws_subnet.MyLab-Subnet.id
    associate_public_ip_address = true
    user_data = file("./installNexus.sh")

    tags = {    
        Name = "SonaTypeNexus"

}
}

