resource "aws_resourcegroups_group" "streamit_resourcegp" {
  name        = var.project_name
  description = "Resources for streamit prod environment"
  resource_query {
    query = <<JSON
    {
        "ResourceTypeFilters": [
            "AWS::AllSupported"
        ],
        "TagFilters": [
            {
                "Key": "Project",
                "Values": ["${var.project_name}"]
            },
            {
                "Key": "Environment",
                "Values": ["prod"]
            },
            {
                "Key": "Type",
                "Values": ["${var.project_type}"]
            }
        ]
    }
    JSON
  }

  tags = {
    Name = "${var.project_name}-resourcegp"
  }
}
