# Tabela DynamoDB para 'users'
resource "aws_dynamodb_table" "users_table" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"

  # Definindo a chave primária (CPF como a chave de partição)
  hash_key = "cpf"

  attribute {
    name = "cpf"
    type = "S"  # 'S' indica que é uma string
  }

  # Tags para a tabela
  tags = {
    Environment = "dev"
    Name        = "users-table"
  }
}

# Tabela DynamoDB para 'users-admin'
resource "aws_dynamodb_table" "users_admin_table" {
  name         = "users-admin"
  billing_mode = "PAY_PER_REQUEST"

  # Definindo a chave primária (UUID como a chave de partição)
  hash_key = "uuid"

  attribute {
    name = "uuid"
    type = "S"  # 'S' indica que é uma string
  }

  # Tags para a tabela
  tags = {
    Environment = "dev"
    Name        = "users-admin-table"
  }
}
