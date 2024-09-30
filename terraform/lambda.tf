data "aws_iam_role" "existing_lab_role" {
  name = "LabRole"
}

locals {
  layer_name  = "dependencies"
  layers_path = "${path.module}/../layers/${local.layer_name}/nodejs"
  lambda_name = "authorizer"
  lambda_path = "${path.module}/../lambdas/${local.lambda_name}/"
  runtime     = "nodejs20.x"
}

resource "null_resource" "build_lambda_layers" {
  triggers = {
    layer_build = md5(file("${local.layers_path}/package.json"))
  }

  provisioner "local-exec" {
    working_dir = "${local.layers_path}"
    command     = "npm install --production && zip -9 -r --quiet ${local.layer_name}.zip *"
  }
}

resource "aws_lambda_layer_version" "this" {
  filename    = "${local.layers_path}/../${local.layer_name}.zip"
  layer_name  = "${local.layer_name}"
  description = "aws-sdk: ^2.1691.0, axios: >=1.6.0, jsonwebtoken: ^9.0.2"

  compatible_runtimes = ["${local.runtime}"]

  depends_on = [null_resource.build_lambda_layers]
}

data "archive_file" "authorizer" {
  type        = "zip"
  output_path = "${local.lambda_path}/${local.lambda_name}.zip"

  source {
    content  = "${file("${local.lambda_path}/app.mjs")}"
    filename = "app.mjs"
  }
}

resource "aws_lambda_function" "authorizer" {
  function_name = local.lambda_name
  handler       = "app.handler"
  runtime       = local.runtime
  filename      = data.archive_file.authorizer.output_path
  source_code_hash = data.archive_file.authorizer.output_base64sha256
  timeout       = 10

  role          = data.aws_iam_role.existing_lab_role.arn
  layers        = [aws_lambda_layer_version.this.arn]

  environment {
    variables = {
      ENV = "dev"
    }
  }
}