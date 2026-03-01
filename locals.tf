locals {
  common_tags = {
    Name = "${var.project}-${var.environment}"
    Project = var.project
    Environment = var.environment
    Terraform = true
  }

  vpc_final_tags = merge(
    local.common_tags,
    var.vpc_tags
  )

  igw_final_tags = merge(
    local.common_tags,
    var.igw_tags
  )
}