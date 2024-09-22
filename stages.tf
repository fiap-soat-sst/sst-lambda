resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format          = jsonencode({
      requestId: "$context.requestId",
      ip: "$context.identity.sourceIp",
      requestTime: "$context.requestTime",
      httpMethod: "$context.httpMethod",
      routeKey: "$context.routeKey",
      status: "$context.status",
      protocol: "$context.protocol",
      responseLength: "$context.responseLength"
    })
  }

  auto_deploy = true
}