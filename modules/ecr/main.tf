resource "aws_ecr_repository" "ecr_lambda_images" {
  name                 = "${var.project}-${var.ecr_container_name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}
