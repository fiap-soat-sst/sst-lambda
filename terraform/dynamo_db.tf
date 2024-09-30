resource "aws_dynamodb_table" "users_table" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "cpf"

  attribute {
    name = "cpf"
    type = "S"
  }

  tags = {
    Environment = "dev"
    Name        = "users-table"
  }
}

resource "aws_dynamodb_table" "users_admin_table" {
  name         = "users-admin"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "uuid"

  attribute {
    name = "uuid"
    type = "S"
  }

  tags = {
    Environment = "dev"
    Name        = "users-admin-table"
  }
}
