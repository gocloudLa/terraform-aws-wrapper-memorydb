module "wrapper_memorydb" {
  source = "../../"

  metadata = local.metadata

  /*----------------------------------------------------------------------*/
  /* MemoryDB Defaults                                                    */
  /*----------------------------------------------------------------------*/

  # memorydb_defaults = {
  #
  #   # Enable alarms for all services
  #   enable_alarms = true # Default: false
  #
  #   # Note: If a value is specified at the service level, that value will be used and the default will not be applied.
  #   alarms_defaults = {
  #     # Default OK and Alarm actions ARNs for alarm notifications
  #     #alarm_actions = ["arn:aws:sns:us-east-1:123456789012:example-alerts"]
  #     #ok_actions    = ["arn:aws:sns:us-east-1:123456789012:example-alerts"]
  #
  #     # Disable specific CloudWatch alarms by default for all services.
  #     #alarms_disabled = ["critical-CPUUtilization", "critical-MemoryUtilization"]
  #    }
  #
  # }

  /*----------------------------------------------------------------------*/
  /* MemoryDB Parameters                                                  */
  /*----------------------------------------------------------------------*/


  memorydb_parameters = {
    "ExSimple" = {
      subnets = data.aws_subnets.database.ids

      # engine_version             = "7.1"
      # auto_minor_version_upgrade = true
      # node_type                  = "db.t4g.small"
      # num_shards                 = 1
      # num_replicas_per_shard     = 0
      # data_tiering               = false
      # tls_enabled                = true

      # parameter_group_family      = "memorydb_redis7"
      # parameter_group_parameters  = [
      #   {
      #     name  = "activedefrag"
      #     value = "yes"
      #   }
      # ]

      users = {
        admin = {
          # CONNECTION MODE: redis-cli -h ${HOST} -p 6379 --tls --user dmc-prd-example-exusers-administrator --pass password_administrator_1234567890
          user_name     = "dmc-prd-example-exusers-administrator"
          passwords     = ["password_administrator_1234567890"]
          access_string = "on ~* &* +@all"
        }
        readonly = {
          # CONNECTION MODE: redis-cli -h ${HOST} -p 6379 --tls --user dmc-prd-example-exusers-readonly --pass password_readonly_1234567890
          user_name     = "dmc-prd-example-exusers-readonly"
          passwords     = ["password_readonly_1234567890"]
          access_string = "on ~* &* -@all +@read"
        }
      }

      dns_records = {
        "" = {
          zone_name    = local.zone_private
          private_zone = true
        }
      }
    }

    "ExMulti" = {
      subnets = data.aws_subnets.database.ids

      num_shards             = 2
      num_replicas_per_shard = 1

      dns_records = {
        "" = {
          zone_name    = local.zone_private
          private_zone = true
        }
      }
    }

    "ExAlarms" = {
      subnets = data.aws_subnets.database.ids

      dns_records = {
        "" = {
          zone_name    = local.zone_private
          private_zone = true
        }
      }

      # ALARMS CONFIGURATION
      enable_alarms = true # Default: false
      alarms_disabled = [  # if you need to disable an alarm
        "critical-CPUUtilization",
        "critical-DatabaseMemoryUsagePercentage",
        "critical-EngineCPUUtilization"
      ]
      # alarms_overrides = {
      #   "warning-CPUUtilization" = {
      #     "actions_enabled"     = true
      #     "evaluation_periods"  = 2
      #     "datapoints_to_alarm" = 2
      #     "threshold"           = 30
      #     "period"              = 180
      #     "treat_missing_data"  = "ignore"
      #   }
      # }

      alarms_custom = {
        # "warning-FreeableMemory" = {
        #   # This alarm helps to monitor low freeable memory which can mean that there is a spike in database connections or that your instance may be under high memory pressure.
        #   description         = "FreeableMemory below 350 MB"
        #   threshold           = 367001600
        #   unit                = "Bytes"
        #   metric_name         = "FreeableMemory"
        #   statistic           = "Average"
        #   period              = 60
        #   evaluation_periods  = 15
        #   datapoints_to_alarm = 15
        #   comparison_operator = "LessThanThreshold"
        #   alarms_tags = {
        #     "alarm-level" = "WARN"
        #   }
        # }
        # "critical-FreeableMemory" = {
        #   description = "FreeableMemory below 250 MB"
        #   # This alarm helps to monitor low freeable memory which can mean that there is a spike in database connections or that your instance may be under high memory pressure.
        #   threshold           = 262144000
        #   unit                = "Bytes"
        #   metric_name         = "FreeableMemory"
        #   statistic           = "Average"
        #   period              = 60
        #   evaluation_periods  = 15
        #   datapoints_to_alarm = 15
        #   comparison_operator = "LessThanThreshold"
        #   alarms_tags = {
        #     "alarm-level" = "CRIT"
        #   }
        # }
        # "warning-SwapUsage" = {
        #   # This alarm helps to monitor the amount of swap used on the host.
        #   description         = "SwapUsage below 300 MB"
        #   threshold           = 300000000
        #   unit                = "Bytes"
        #   metric_name         = "SwapUsage"
        #   statistic           = "Average"
        #   period              = 60
        #   evaluation_periods  = 15
        #   datapoints_to_alarm = 15
        #   comparison_operator = "GreaterThanThreshold"
        #   alarms_tags = {
        #     "alarm-level" = "WARN"
        #   }
        # }
        # "critical-SwapUsage" = {
        #   description = "SwapUsage below 250 MB"
        #   # This alarm helps to monitor the amount of swap used on the host.
        #   threshold           = 200000000
        #   unit                = "Bytes"
        #   metric_name         = "SwapUsage"
        #   statistic           = "Average"
        #   period              = 60
        #   evaluation_periods  = 15
        #   datapoints_to_alarm = 15
        #   comparison_operator = "GreaterThanThreshold"
        #   alarms_tags = {
        #     "alarm-level" = "CRIT"
        #   }
        # }        
        # "warning-CurrConnections" = {
        #   # This alarm is used to detect the number of client connections, excluding connections from read replicas.
        #   description         = "Triggers if the number of client connections is above the threshold of 350 connections"
        #   threshold           = 350
        #   unit                = "Count"
        #   metric_name         = "CurrConnections"
        #   statistic           = "Average"
        #   period              = 60
        #   evaluation_periods  = 3
        #   datapoints_to_alarm = 3
        #   comparison_operator = "GreaterThanThreshold"
        #   alarms_tags = {
        #     "alarm-level" = "WARN"
        #   }
        # }
        # "critical-CurrConnections" = {
        #   # This alarm is used to detect the number of client connections, excluding connections from read replicas.
        #   description         = "Triggers if the number of client connections is above the threshold of 500 connections"
        #   threshold           = 500
        #   unit                = "Count"
        #   metric_name         = "CurrConnections"
        #   statistic           = "Average"
        #   period              = 60
        #   evaluation_periods  = 3
        #   datapoints_to_alarm = 3
        #   comparison_operator = "GreaterThanThreshold"
        #   alarms_tags = {
        #     "alarm-level" = "CRIT"
        #   }
        # }
      }
    }
  }
}