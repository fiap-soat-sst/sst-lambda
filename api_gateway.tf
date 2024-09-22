resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "SelfServiceTotemAPI"
  protocol_type = "HTTP"
}

