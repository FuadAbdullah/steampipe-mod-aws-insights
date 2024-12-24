dashboard "backup_recovery_point_inventory" {

  title         = "AWS Backup Recovery Point Inventory"
  documentation = file("./dashboards/backup/docs/backup_vault_detail.md")

  tags = merge(local.backup_common_tags, {
    type = "Inventory"
  })

  input "backup_vault_rp_input" {
    title = "Select a vault:"
    query = query.backup_vault_input
    width = 4
  }

  container {
    table {
      title = "Recovery Points"
      query = query.backup_vault_recovery_points_records
      args = [self.input.backup_vault_rp_input.value]
    }
  }

}

# Input queries

query "backup_vault_rp_input" {
  sql = <<-EOQ
    select
      title as label,
      arn as value,
      json_build_object(
        'account_id', account_id,
        'region', region
      ) as tags
    from
      aws_backup_vault
    order by
      arn;
  EOQ
}

# Card queries

query "backup_vault_recovery_points_records" {
  sql = <<-EOQ
    select
      rp.recovery_point_arn as "ARN",
      rp.backup_vault_arn as "Vault ARN",
      rp.resource_arn as "Resource ARN",
      rp.backup_vault_name as "Vault Name",
      rp.resource_name as "Resource Name",
      rp.resource_type as "Resource Type",
      rp.creation_date as "Creation Date",
      rp.completion_date as "Completion Date",
      rp.status as "Status",
      rp.status_message as "Status Message",
      rp.is_encrypted as "Is Encrypted?",
      rp.storage_class as "Class",
      rp.account_id as "Account ID",
      rp.region as "Region"
    from 
      aws_backup_recovery_point as rp
    where
      rp.backup_vault_arn = $1
      and rp.account_id = split_part($1, ':', 5)
      and rp.region = split_part($1, ':', 4)
  EOQ
}
