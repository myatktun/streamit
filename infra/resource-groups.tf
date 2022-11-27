resource "aws_resourcegroups_group" "streamit_resourcegp" {
  name        = "streamit"
  description = "Resources for streamit dev environment"
  resource_query {
    query = <<JSON
    {
        "ResourceTypeFilters": [
            "AWS::EC2::Instance",
            "AWS::ECR::Repository"
        ],
        "TagFilters": [
            {
                "Key": "Project",
                "Values": ["streamit"]
            },
            {
                "Key": "Environment",
                "Values": ["dev"]
            },
            {
                "Key": "Type",
                "Values": ["web-app"]
            }
        ]
    }
    JSON
  }

  tags = {
    Name        = "streamit"
    Environment = "dev"
  }
}
