## Setup

Pre-requisites to running project:

1. Have shared credentials file setup in home directory

2. Terraform version 0.12.9 or higher installed

3. Setup initial backend else the code will fail

```
cd setup

terraform init

terraform apply

```

Navigate back to to root dir and run the project:

```bash

cd ..

# Initialise this folder

terraform init 

# Plan changes

terraform plan -var-file terraform.tfvars

# Apply changes

terraform apply -var-file terraform.tfvars

``` 

### Improvements

Unfortunately I cannot allocate more time to this project due to other pressing commitments

Changes I'd have liked to make is separate and modularise the different components and also add more 
variable options.
