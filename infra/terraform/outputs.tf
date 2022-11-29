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
  value       = aws_vpc.streamit_vpc.id
  description = "streamit VPC ID"
  sensitive   = false
}

output "region" {
  value       = var.region
  description = "AWS Region"
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.streamit_cluster.name
}
