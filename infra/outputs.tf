output "aws-storage_repository_url" {
  value = aws_ecr_repository.streamit_aws-storage.repository_url
}

output "video-streaming_repository_url" {
  value = aws_ecr_repository.streamit_video-streaming.repository_url
}

output "view-history_repository_url" {
  value = aws_ecr_repository.streamit_view-history.repository_url
}
