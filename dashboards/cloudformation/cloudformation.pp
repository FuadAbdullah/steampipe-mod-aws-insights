locals {
  cloudformation_common_tags = {
    service = "AWS/CloudFormation"
  }
}

category "cloudformation_stack" {
  title = "CloudFormation Stack"
  color = local.management_governance_color
  icon  = "category"
}
