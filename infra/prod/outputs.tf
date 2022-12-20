output "aws-storage_repository_url" {
  value = aws_ecr_repository.streamit_aws-storage.repository_url
}

output "video-streaming_repository_url" {
  value = aws_ecr_repository.streamit_video-streaming.repository_url
}

output "view-history_repository_url" {
  value = aws_ecr_repository.streamit_view-history.repository_url
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "streamit VPC ID"
  sensitive   = false
}

output "region" {
  value       = var.region
  description = "AWS Region"
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}
