resource "aws_resourcegroups_group" "streamit" {
  name        = "streamit"
  description = "Resources for streamit dev environment"
  resource_query {
    query = <<JSON
    {
        "ResourceTypeFilters": [
            "AWS::EC2::Instance"
        ],
        "TagFilters": [
            {
                "Key": "Environment",
                "Values": ["Dev"]
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
