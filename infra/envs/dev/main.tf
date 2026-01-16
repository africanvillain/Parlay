module "vpc" {
  source = "../../modules/vpc"

  name            = "parlay-dev"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
}

####################
#    EKS           #
####################
module "eks" {
  source = "../../modules/eks"

  cluster_name       = "parlay-dev"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}


####################
#      ECR         #
####################
module "ecr" {
  source = "../../modules/ecr"
  name   = "parlay-analyzer"
}
