dashboard "cloudformation_stack_inventory" {

  title         = "AWS CloudFormation Stack Inventory"
  documentation = file("./dashboards/cloudformation/docs/cloudformation_stack_inventory.md")

  tags = merge(local.cloudformation_common_tags, {
    type = "Inventory"
  })

  container {

    card {
      query = query.cloudformation_stack_inventory_count
      width = 2

    }
  }

  container {

    table {
      width = 12
      title = "Stacks"
      query = query.cloudformation_stack_inventory
    }
  }

}

# Card query

query "cloudformation_stack_inventory_count" {
  sql = <<-EOQ
    select
      count(*) as "Stacks"
    from
      aws_cloudformation_stack
  EOQ
}

# Table query

query "cloudformation_stack_inventory" {
  sql = <<-EOQ
    select
      st.id as "ARN",
      st.name as "Name",
      st.name as "Description",
      st.creation_time as "Creation Time",
      st.last_updated_time as "Update Time",
      st.status as "Status",
      st.stack_status_reason as "Status Reason",
      st.disable_rollback::bool as "Rollback is disabled?",
      st.enable_termination_protection::bool as "Termination protection is enabled?",
      st.parent_id as "Stack Parent ID",
      st.region as "Region",
      st.account_id as "Account ID"
    from
      aws_cloudformation_stack as st
  EOQ
}