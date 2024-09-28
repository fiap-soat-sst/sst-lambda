# Log group para o API Gateway
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "api_gateway_logs"
  retention_in_days = 7
}