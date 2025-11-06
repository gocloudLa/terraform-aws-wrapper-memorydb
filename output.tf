
# output "memorydb" {
#   value = module.memorydb
# }

output "aws_route53_record" {
  description = "Alias DNS Records"
  value       = { for k, v in aws_route53_record.memorydb : k => v.fqdn }

}

# output "cluster" {
#   value = { for k, v in module.memorydb : k => v.cluster_shards }
#   #module.memorydb[0].cluster_shards
# }
