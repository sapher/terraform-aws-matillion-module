# Matillion for snowflake

For this module to work, you need to subscribe to [Matillion for Snowflake](https://aws.amazon.com/marketplace/pp/B073GRSSZD?ref_=aws-mp-console-subscription-detail) on AWS Marketplace.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | -------- |
| profile | AWS profile | string | `default` | - |
| region | AWS region | string | - | yes |
| instance_type | Matillion instance type | string | `m5.large` | - |
| vpc_id | VPC ID | string | - | yes |
| public_subnet_ids | Public subnet Ids | list(string) | - | yes |
| whitelist_ips | Whitelisted IPs for load balancer security group | list(string) | `["0.0.0.0/0"]` | yes |
| matillion_log_group | Cloudwatch log group for Matillion instance | string | `/matillion` | - |
| matillion_sg_ids | Matillion instance security groups (security group from ALB will not be override) | list(string) | `[]` | - |

## Outputs

| Name | Description |
| ---- | ----------- |
| matillion_instance_id | Matillion instance id (used as default password for user `ec2-user` |
| matillion_lb_dns_name | Matillion load balancer DNS name |
