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
| [terraform-aws-modules/memory-db/aws](https://github.com/terraform-aws-modules/memory-db-aws) | 2.3.0 |
| [terraform-aws-modules/security-group/aws](https://github.com/terraform-aws-modules/security-group-aws) | 5.3.0 |



## 🚀 Quick Start
```hcl
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
        # MODO DE CONEXION: redis-cli -h ${HOST} -p 6379 --tls --user dmc-prd-example-exusers-administrator --pass password_administrator_1234567890
        user_name     = "dmc-prd-example-exusers-administrator"
        passwords     = ["password_administrator_1234567890"]
        access_string = "on ~* &* +@all"
      }
      readonly = {
        # MODO DE CONEXION: redis-cli -h ${HOST} -p 6379 --tls --user dmc-prd-example-exusers-readonly --pass password_readonly_1234567890
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










---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la
- 🐛 **Issues**: [GitHub Issues](https://github.com/gocloudLa/issues)

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 