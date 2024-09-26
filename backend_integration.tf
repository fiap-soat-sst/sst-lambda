data "aws_eks_cluster" "sst_eks" {
  name = "self-service-totem"
}

# Integração HTTP Proxy
resource "aws_apigatewayv2_integration" "backend_integration" {
  depends_on = [ aws_apigatewayv2_api.api_gateway ]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_eks_cluster.sst_eks.endpoint
  integration_method = "ANY"
}