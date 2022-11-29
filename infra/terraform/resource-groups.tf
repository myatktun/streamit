resource "aws_resourcegroups_group" "streamit_resourcegp" {
  name        = var.project_name
  description = "Resources for streamit dev environment"
  resource_query {
    query = <<JSON
    {
        "ResourceTypeFilters": [
            "AWS::EC2::VPC",
            "AWS::EC2::Subnet",
            "AWS::EC2::InternetGateway",
            "AWS::EC2::EIP",
            "AWS::EC2::NatGateway",
            "AWS::EC2::Instance",
            "AWS::ECR::Repository"
        ],
        "TagFilters": [
            {
                "Key": "Project",
                "Values": ["${var.project_name}"]
            },
            {
                "Key": "Environment",
                "Values": ["dev"]
            },
            {
                "Key": "Type",
                "Values": ["${var.project_type}"]
            }
        ]
    }
    JSON
  }

  tags = var.default_tags
}
