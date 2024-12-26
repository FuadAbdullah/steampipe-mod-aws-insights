dashboard "sns_topic_subscription_inventory" {

  title         = "AWS SNS Topic Subscription Inventory"
  documentation = file("./dashboards/sns/docs/sns_topic_subscription_inventory.md")

  tags = merge(local.sns_common_tags, {
    type = "Inventory"
  })

  container {

    card {
      query = query.sns_topic_subscription_inventory_count
      width = 3

    }
  }

  container {

    table {
      width = 12
      title = "Stacks"
      query = query.sns_topic_subscription_inventory
    }
  }

}

# Card query

query "sns_topic_subscription_inventory_count" {
  sql = <<-EOQ
    select
      count(*) as "Topic Subscriptions"
    from
      aws_sns_topic_subscription
  EOQ
}

# Table query

query "sns_topic_subscription_inventory" {
  sql = <<-EOQ
    select
      ts.subscription_arn as "Subscription ARN",
      ts.protocol as "Protocol",
      ts.pending_confirmation as "Pending Confirmation",
      ts.owner as "Owner",
      topic.display_name as "Display Name",
      ts.topic_arn as "Topic ARN",
      ts.endpoint as "Endpoint",
      ts.confirmation_was_authenticated as "Confirmation was authenticated?",
      ts.region as "Region",
      ts.account_id as "Account ID"
    from
      aws_sns_topic_subscription as ts
    join 
      aws_sns_topic topic on ts.topic_arn = topic.topic_arn;
  EOQ
}