resource "null_resource" "docker-build" {
  provisioner "local-exec" {
    command = "docker build --build-arg REACT_APP_BACKEND_URL=${aws_alb.backend_main.dns_name} -f ../src/frontend/Dockerfile.prod -t sample:prod ../src/frontend"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "docker-login" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "docker-tag" {
  provisioner "local-exec" {
    command = "docker tag sample:prod $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/frontend"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "docker-push" {
  provisioner "local-exec" {
    command = "docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/frontend"
    interpreter = ["bash", "-c"]
  }
}