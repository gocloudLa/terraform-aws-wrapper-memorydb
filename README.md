# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform MemoryDB Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-memorydb/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-memorydb.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-memorydb.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-memorydb/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
The Terraform Wrapper for MemoryDB simplifies the creation of Amazon's MemoryDB (Redis compatible) service, creates clusters, distributes DNS, and associates SecurityGroup with the service.

### ✨ Features



### 🔗 External Modules
| Name | Version |
|------|------:|
| <a href="https://github.com/terraform-aws-modules/terraform-aws-memory-db" target="_blank">terraform-aws-modules/memory-db/aws</a> | 2.3.0 |
| <a href="https://github.com/terraform-aws-modules/terraform-aws-security-group" target="_blank">terraform-aws-modules/security-group/aws</a> | 5.3.0 |



## 🚀 Quick Start
```hcl
memorydb_parameters = {
  "ExSimple" = {
    subnets = data.aws_subnets.database.ids

    engine_version             = "7.1"
    parameter_group_family      = "memorydb_redis7"
    
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
}
elasticache_defaults = var.elasticache_defaults
```


## 🔧 Additional Features Usage



## 📑 Inputs
| Name                          | Description                                                                                                                                                                       | Type     | Default | Required |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- | -------- |
| `engine`                      | The engine that will run on your nodes. Supported values are redis and valkey                                                                                                     | `string` | `null`  | no       |
| `engine_version`              | Version number of the engine to be used for the cluster. Downgrades are not supported                                                                                             | `string` | `null`  | no       |
| `auto_minor_version_upgrade`  | When set to `true`, the cluster will automatically receive minor engine version upgrades after launch. Defaults to `true`                                                         | `bool`   | `null`  | no       |
| `node_type`                   | The compute and memory capacity of the nodes in the cluster. See AWS documentation on supported node types as well as vertical scaling                                            | `string` | `null`  | no       |
| `num_shards`                  | The number of shards in the cluster. Defaults to `1`                                                                                                                              | `number` | `null`  | no       |
| `num_replicas_per_shard`      | The number of replicas to apply to each shard, up to a maximum of 5. Defaults to `1` (i.e. 2 nodes per shard)                                                                     | `number` | `null`  | no       |
| `data_tiering`                | Must be set to `true` when using a data tiering node type                                                                                                                         | `bool`   | `null`  | no       |
| `tls_enabled`                 | A flag to enable in-transit encryption on the cluster. When set to `false`, the `acl_name` must be `open-access`. Defaults to `true`                                              | `bool`   | `null`  | no       |
| `security_group_ids`          | Set of VPC Security Group ID-s to associate with this cluster                                                                                                                     | `list`   | `null`  | no       |
| `snapshot_arns`               | List of ARN-s that uniquely identify RDB snapshot files stored in S3. The snapshot files will be used to populate the new cluster                                                 | `list`   | `null`  | no       |
| `maintenance_window`          | Specifies the weekly time range during which maintenance on the cluster is performed. It is specified as a range in the format `ddd:hh24:mi-ddd:hh24:mi`                          | `string` | `null`  | no       |
| `snapshot_retention_limit`    | The number of days for which MemoryDB retains automatic snapshots before deleting them. When set to `0`, automatic backups are disabled. Defaults to `0`                          | `number` | `null`  | no       |
| `snapshot_window`             | The daily time range (in UTC) during which MemoryDB begins taking a daily snapshot of your shard. Example: `05:00-09:00`                                                          | `string` | `null`  | no       |
| `users`                       | A map of user definitions (maps) to be created                                                                                                                                    | `any`    | `{}`    | no       |
| `acl_name`                    | Name of ACL to be created if `create_acl` is `true`, otherwise it's the name of an existing ACL to use if `create_acl` is `false`                                                 | `string` | `null`  | no       |
| `parameter_group_name`        | Name of parameter group to be created if `create_parameter_group` is `true`, otherwise it's the name of an existing parameter group to use if `create_parameter_group` is `false` | `string` | `null`  | no       |
| `parameter_group_description` | Description for the parameter group. Defaults to `Managed by Terraform`                                                                                                           | `string` | `null`  | no       |
| `parameter_group_family`      | The engine version that the parameter group can be used with                                                                                                                      | `string` | `null`  | no       |
| `parameter_group_parameters`  | A list of parameter maps to apply                                                                                                                                                 | `null`   | `[]`    | no       |
| `subnet_group_name`           | Name of subnet group to be created if `create_subnet_group` is `true`, otherwise it's the name of an existing subnet group to use if `create_subnet_group` is `false`             | `string` | `null`  | no       |
| `subnet_group_description`    | Description for the subnet group. Defaults to `Managed by Terraform`                                                                                                              | `string` | `null`  | no       |
| `subnet_ids`                  | Set of VPC Subnet ID-s for the subnet group. At least one subnet must be provided                                                                                                 | `list`   | `[]`    | no       |
| `tags`                        | A map of tags to use on all resources                                                                                                                                             | `map`    | `{}`    | no       |








---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 