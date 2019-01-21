# Terraform Module for Creating Dynamic VPCs in AWS
A Terraform module for creating dynamic VPCs with configurable Private and Public Subnets, NAT Gatways, etc. 


You can use this Terraform Module to create AWS VPC that can have 0 or more public and private subnets. The module creates necessary route tables, subnet association, NAT gateways and Internet Gatways. It dynamically selects different availablity zone if more than one public and/or private subnet is created. 

You must set the following variables: 
```sh
vpc_cidr = ""  
vpc_name = ""   
public_subnet_cidrs = []   
private_subnet_cidrs = []   
tags = {}   
```

#### To Create a VPC
You can rename terraform.tfvars.example to terraform.tfvars and update it with your variables. Then you can run 

```sh
terraform apply 
```

#### To destroy a VPC that was created using this module
```sh 
terraform destroy
```

