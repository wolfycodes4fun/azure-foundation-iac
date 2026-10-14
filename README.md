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

**Github Actions Demo Pipeline**

To provision and configure the environment via a pipeline (for no useful reason, just for the fun of it), Github Actions has been used. A service principal in Azure has been created ("azure-foundation-iac-spn") and assigned the roles of 'Contributor', 'Storage Blob Data Owner' & 'User Access Administrator' to the subscription where I carry out my workings.

The 'provision-resources' file defines the pipeline configuration to spin up the storage account to hold the TF state and the subsequent resources needed in the environment.