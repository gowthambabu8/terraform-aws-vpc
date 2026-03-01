locals {
  common_tags = {
    Project = var.project
    Environment = var.environment
    Terraform = true
  }

  tags = merge(
    local.common_tags,
    var.vpc_tags,
    {
        Name = "${var.project}-${var.environment}"
    }
  )
}