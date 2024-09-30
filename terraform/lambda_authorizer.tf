resource "aws_apigatewayv2_authorizer" "lambda_authorizer" {  
  depends_on                   = [ aws_lambda_function.authorizer ]
  name                         = "lambda_authorizer"
  api_id                       = aws_apigatewayv2_api.api_gateway.id
  authorizer_type              = "REQUEST"
  authorizer_uri               = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.authorizer.arn}/invocations"
  authorizer_payload_format_version = "2.0"
  authorizer_result_ttl_in_seconds = 3600
  identity_sources = ["$request.header.token"]
}

resource "aws_lambda_permission" "allow_api_gateway" {
  depends_on = [ aws_lambda_function.authorizer, aws_apigatewayv2_api.api_gateway ]
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}