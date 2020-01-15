provider "aws" {
  region              = var.region_production
  allowed_account_ids = [ var.aws_account_production ]
  version             = "~> 2.0"
}

data "terraform_remote_state" "network_production" {
  backend = "local"
  config = {
    path = "./../../network/10_production/terraform.tfstate"
  } 
}

module "aws_env_base_mgmt" {
  source           = "./../../modules/aws-env-base"
  env              = var.env_name_mgmt
  vpc              = data.terraform_remote_state.network_production.outputs.mgmt_vpc_id
  public_subnet_a  = data.terraform_remote_state.network_production.outputs.mgmt_subnet_public_a
  public_subnet_b  = data.terraform_remote_state.network_production.outputs.mgmt_subnet_public_b
  public_subnet_c  = data.terraform_remote_state.network_production.outputs.mgmt_subnet_public_c
  private_subnet_a = data.terraform_remote_state.network_production.outputs.mgmt_subnet_private_a
  private_subnet_b = data.terraform_remote_state.network_production.outputs.mgmt_subnet_private_b
  private_subnet_c = data.terraform_remote_state.network_production.outputs.mgmt_subnet_private_c
  cidr_block       = data.terraform_remote_state.network_production.outputs.mgmt_cidr_block
}

module "aws_env_base_prod" {
  source           = "./../../modules/aws-env-base"
  env              = var.env_name_prod
  public_subnet_a  = data.terraform_remote_state.network_production.outputs.prod_subnet_public_a
  public_subnet_b  = data.terraform_remote_state.network_production.outputs.prod_subnet_public_b
  public_subnet_c  = data.terraform_remote_state.network_production.outputs.prod_subnet_public_c
  private_subnet_a = data.terraform_remote_state.network_production.outputs.prod_subnet_private_a
  private_subnet_b = data.terraform_remote_state.network_production.outputs.prod_subnet_private_b
  private_subnet_c = data.terraform_remote_state.network_production.outputs.prod_subnet_private_c
  vpc              = data.terraform_remote_state.network_production.outputs.prod_vpc_id
  cidr_block       = data.terraform_remote_state.network_production.outputs.prod_cidr_block
  create_rds_base  = true
}
