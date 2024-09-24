data "aws_iam_role" "existing_lambda_role" {
  name = "LabRole"
}

resource "aws_lambda_function" "authorizer" {
  function_name = "my_lambda_authorizer"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "index.zip"
  timeout       = 10

  role          = data.aws_iam_role.existing_lambda_role.arn

  environment {
    variables = {
      ENV = "dev"
    }
  }
}