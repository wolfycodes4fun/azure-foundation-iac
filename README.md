**🏛️ Infrastructure as Code — Azure Environment from Scratch**

The following project consists of full Terraform code to provision an Azure environment. The provisoned environment consists of the following components/architecture:  
* Virtual Network with public/private subnets across 2 Availability Zones
* Virtual Machine instance in a private subnet
* Bastion host in public subnet for SSH connectivity
* A Level 4 Load Balancer
* Azure SQL Database in a dedicated DB subnet
* NSGs with least-privilege rules
* Storage accounts for persistent storage
* Blob Container to store remote state