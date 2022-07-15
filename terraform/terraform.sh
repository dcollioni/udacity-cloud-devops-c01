# initialise terraform module
terraform init

# compile terraform module into a plan
terraform plan -out solution.plan

# apply (deploy) the plan
terraform apply solution.plan

# show the applied plan
terraform show

# destroy the applied plan
terraform destroy
