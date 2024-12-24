dashboard "cloudwatch_alarms_detail" {
  title         = "AWS CloudWatch Alarms Detail"
  documentation = file("./dashboards/cloudwatch/docs/cloudwatch_alarms_detail.md")

  tags = merge(local.cloudwatch_common_tags, {
    type = "Detail"
  })

  input "alarm_arn" {
    title = "Select an alarm:"
    query = query.cloudwatch_alarm_input
    width = 4
  }

  container {

    card {
      query = query.cloudwatch_alarm_namespace
      width = 3
      args  = [self.input.alarm_arn.value]
    }

    card {
      query = query.cloudwatch_alarm_state
      width = 3
      args  = [self.input.alarm_arn.value]
    }

  }
}

# Input queries

query "cloudwatch_alarm_input" {
  sql = <<-EOQ
    select
      title as label,
      arn as value,
      json_build_object(
        'account_id', account_id,
        'region', region,
        'arn', arn
      ) as tags
    from
      aws_cloudwatch_alarm
    order by
      title;
  EOQ
}

# Card queries

query "cloudwatch_alarm_namespace" {
  sql = <<-EOQ
    select
      namespace as value,
      'Namespace' as label
    from
      aws_cloudwatch_alarm
    where
      arn = $1
      and region = split_part($1, ':', 4)
      and account_id = split_part($1, ':', 5);
  EOQ
}

query "cloudwatch_alarm_state" {
  sql = <<-EOQ
    select
      state_value as value,
      'State' as label
    from
      aws_cloudwatch_alarm
    where
      arn = $1
      and region = split_part($1, ':', 4)
      and account_id = split_part($1, ':', 5);
  EOQ
}