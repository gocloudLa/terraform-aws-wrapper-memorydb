#########################################################################################################
#                                                                                                       #
# Documentation: https://docs.aws.amazon.com/memorydb/latest/devguide/metrics.whichshouldimonitor.html  #
#                                                                                                       #
#########################################################################################################

locals {
  alarms_default = {
    "warning-CPUUtilization" = {
      # This alarm is used to detect a high MemoryDB load.
      description         = "is using more than 75% of CPU"
      threshold           = 75
      unit                = "Percent"
      metric_name         = "CPUUtilization"
      statistic           = "Average"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 5
      datapoints_to_alarm = 5
      alarms_tags = {
        "alarm-level" = "WARN"
      }
    }
    "critical-CPUUtilization" = {
      # This alarm is used to detect a high MemoryDB load.
      description         = "is using more than 90% of CPU"
      threshold           = 90
      unit                = "Percent"
      metric_name         = "CPUUtilization"
      statistic           = "Average"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 5
      datapoints_to_alarm = 5
      alarms_tags = {
        "alarm-level" = "CRIT"
      }
    }
    "warning-DatabaseMemoryUsagePercentage" = {
      # This alarm is used to detect the percentage of the memory available for the cluster that is in use.
      description         = "is using more than 75% of memory"
      threshold           = 75
      unit                = "Percent"
      metric_name         = "DatabaseMemoryUsagePercentage"
      statistic           = "Average"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      alarms_tags = {
        "alarm-level" = "WARN"
      }
    }
    "critical-DatabaseMemoryUsagePercentage" = {
      # This alarm is used to detect the percentage of the memory available for the cluster that is in use.
      description         = "is using more than 90% of memory"
      threshold           = 90
      unit                = "Percent"
      metric_name         = "DatabaseMemoryUsagePercentage"
      statistic           = "Average"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      alarms_tags = {
        "alarm-level" = "CRIT"
      }
    }
    "warning-EngineCPUUtilization" = {
      # This alarm is used to detect CPU utilization of the Valkey or Redis OSS engine thread.
      description         = "is using more than 85% of memory"
      threshold           = 85
      unit                = "Percent"
      metric_name         = "EngineCPUUtilization"
      statistic           = "Average"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      alarms_tags = {
        "alarm-level" = "WARN"
      }
    }
    "critical-EngineCPUUtilization" = {
      # This alarm is used to detect CPU utilization of the Valkey or Redis OSS engine thread.
      description         = "is using more than 90% of memory"
      threshold           = 90
      unit                = "Percent"
      metric_name         = "EngineCPUUtilization"
      statistic           = "Average"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      alarms_tags = {
        "alarm-level" = "CRIT"
      }
    }
  }
  alarms_default_tmp = merge([
    for memorydb_name, values in try(var.memorydb_parameters, []) : {
      for alarm, value in try(local.alarms_default, {}) :
      "${memorydb_name}-${alarm}" =>
      merge(
        value,
        {
          alarm_name          = "MemoryDB-${alarm}-${local.common_name}-${memorydb_name}"
          alarm_description   = "MemoryDB[${memorydb_name}] ${value.description}"
          actions_enabled     = try(values.alarms_overrides[alarm].actions_enabled, true)
          threshold           = try(values.alarms_overrides[alarm].threshold, value.threshold)
          unit                = try(values.alarms_overrides[alarm].unit, value.unit)
          metric_name         = try(values.alarms_overrides[alarm].metric_name, value.metric_name)
          namespace           = try(values.alarms_overrides[alarm].namespace, value.namespace, "AWS/MemoryDB")
          evaluation_periods  = try(values.alarms_overrides[alarm].evaluation_periods, value.evaluation_periods, null)
          datapoints_to_alarm = try(values.alarms_overrides[alarm].datapoints_to_alarm, value.datapoints_to_alarm, null)
          statistic           = try(values.alarms_overrides[alarm].statistic, value.statistic, null)
          extended_statistic  = try(values.alarms_overrides[alarm].extended_statistic, value.extended_statistic, null)
          comparison_operator = try(values.alarms_overrides[alarm].comparison_operator, value.comparison_operator)
          period              = try(values.alarms_overrides[alarm].period, value.period, 60)
          treat_missing_data  = try(values.alarms_overrides[alarm].treat_missing_data, "notBreaching")
          ok_actions    = try(values.alarms_overrides[alarm].ok_actions, var.memorydb_defaults.alarms_defaults.ok_actions, [])
          alarm_actions = try(values.alarms_overrides[alarm].alarm_actions, var.memorydb_defaults.alarms_defaults.alarm_actions, [])
          alarms_tags   = merge(try(values.alarms_overrides[alarm].alarms_tags, value.alarms_tags), { "alarm-memorydb-name" = "${local.common_name}-${memorydb_name}" })
      }) if can(var.memorydb_parameters) && var.memorydb_parameters != {} && try(values.enable_alarms, var.memorydb_defaults.enable_alarms, false) && !contains(try(values.alarms_disabled, var.memorydb_defaults.alarms_defaults.alarms_disabled, []), alarm)
    }
  ]...)

  alarms_custom_tmp = merge([
    for memorydb_name, values in try(var.memorydb_parameters, []) : {
      for alarm, value in try(values.alarms_custom, {}) :
      "${memorydb_name}-${alarm}" => merge(
        value,
        {
          alarm_name          = "MemoryDB-${alarm}-${local.common_name}-${memorydb_name}"
          alarm_description   = "MemoryDB[${memorydb_name}] ${value.description}"
          actions_enabled     = try(value.actions_enabled, true)
          threshold           = value.threshold
          unit                = value.unit
          metric_name         = value.metric_name
          namespace           = try(value.namespace, "AWS/MemoryDB")
          evaluation_periods  = try(value.evaluation_periods, null)
          datapoints_to_alarm = try(value.datapoints_to_alarm, null)
          statistic           = try(value.statistic, null)
          extended_statistic  = try(value.extended_statistic, null)
          comparison_operator = value.comparison_operator
          period              = value.period
          treat_missing_data  = try("${value.treat_missing_data}", "notBreaching")
          dimensions = try(value.dimensions, {
            ClusterName = lower("${local.common_name}-${memorydb_name}")
          })
          ok_actions    = try(value.ok_actions, var.memorydb_defaults.alarms_defaults.ok_actions, [])
          alarm_actions = try(value.alarm_actions, var.memorydb_defaults.alarms_defaults.alarm_actions, [])
          alarms_tags   = merge(try(values.alarms_overrides[alarm].alarms_tags, value.alarms_tags), { "alarm-memorydb-name" = "${local.common_name}-${memorydb_name}" })
        }
      ) if can(var.memorydb_parameters) && var.memorydb_parameters != {} && try(values.enable_alarms, var.memorydb_defaults.enable_alarms, false)
    }
  ]...)

  alarms = merge(
    local.alarms_default_tmp,
    local.alarms_custom_tmp
  )

  # Shard-level alarms - creates a flat map for for_each
  alarms_for_shard = merge(flatten([
    for memorydb_name, memorydb_config in var.memorydb_parameters : [
      # Iterate through each shard group (num_shards) and for each shard group iterate through its replicas (num_replicas_per_shard)
      # This creates alarms for each individual node in the shard
      for shards_group_idx in range(try(memorydb_config.num_shards, 1)) : [
        for replica_idx in range(try(memorydb_config.num_replicas_per_shard, 0) + 1) : [
          for alarm_name, alarm in local.alarms : {
            "${memorydb_name}-${shards_group_idx}-${replica_idx}-${alarm_name}" = merge(
              alarm,
              {
                alarm_name        = "${split("/", alarm.namespace)[1]}-${alarm.alarm_name}-${tolist(tolist(module.memorydb[memorydb_name].cluster_shards)[shards_group_idx].nodes)[replica_idx].name}"
                alarm_description = "MemoryDB[${tolist(tolist(module.memorydb[memorydb_name].cluster_shards)[shards_group_idx].nodes)[replica_idx].name}] ${alarm.description}"
                dimensions = {
                  ClusterName = lower("${local.common_name}-${memorydb_name}")
                  NodeName    = tolist(tolist(module.memorydb[memorydb_name].cluster_shards)[shards_group_idx].nodes)[replica_idx].name
                }
              }
            )
          } if startswith(alarm_name, "${memorydb_name}-")
        ]
      ]
    ] if can(var.memorydb_parameters) && var.memorydb_parameters != {} && try(memorydb_config.enable_alarms, var.memorydb_defaults.enable_alarms, false)
  ])...)

}

/*----------------------------------------------------------------------*/
/* SNS Alarms Variables                                                 */
/*----------------------------------------------------------------------*/

locals {
  enable_alarms_sns_default = anytrue([
    for _, alarm_value in local.alarms :
    length(alarm_value.ok_actions) == 0 || length(alarm_value.alarm_actions) == 0
  ]) ? 1 : 0
}

data "aws_sns_topic" "alarms_sns_topic_name" {
  count = local.enable_alarms_sns_default
  name  = local.default_sns_topic_name
}

/*----------------------------------------------------------------------*/
/* CW Alarms Variables                                                  */
/*----------------------------------------------------------------------*/

resource "aws_cloudwatch_metric_alarm" "alarms" {
  for_each = nonsensitive(local.alarms_for_shard)

  alarm_name          = each.value.alarm_name
  alarm_description   = each.value.alarm_description
  actions_enabled     = each.value.actions_enabled
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  datapoints_to_alarm = each.value.datapoints_to_alarm
  threshold           = each.value.threshold
  period              = each.value.period
  unit                = each.value.unit
  namespace           = each.value.namespace
  metric_name         = each.value.metric_name
  statistic           = each.value.statistic
  extended_statistic  = each.value.extended_statistic
  dimensions          = each.value.dimensions
  treat_missing_data  = each.value.treat_missing_data

  alarm_actions = length(each.value.alarm_actions) == 0 ? [data.aws_sns_topic.alarms_sns_topic_name[0].arn] : each.value.alarm_actions
  ok_actions    = length(each.value.ok_actions) == 0 ? [data.aws_sns_topic.alarms_sns_topic_name[0].arn] : each.value.ok_actions

  # conflicts with metric_name
  dynamic "metric_query" {
    for_each = try(each.value.metric_query, var.memorydb_defaults.alarms_defaults.metric_query, [])
    content {
      id          = lookup(metric_query.value, "id")
      account_id  = lookup(metric_query.value, "account_id", null)
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", null)
      expression  = lookup(metric_query.value, "expression", null)
      period      = lookup(metric_query.value, "period", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", [])
        content {
          metric_name = lookup(metric.value, "metric_name")
          namespace   = lookup(metric.value, "namespace")
          period      = lookup(metric.value, "period")
          stat        = lookup(metric.value, "stat")
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
    }
  }
  threshold_metric_id = try(each.value.threshold_metric_id, var.memorydb_defaults.alarms_defaults.threshold_metric_id, null)

  tags = merge(try(each.value.tags, {}), local.common_tags, try(each.value.alarms_tags, {}))
}