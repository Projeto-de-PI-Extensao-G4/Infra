#Criacao dos S3 para analise de dados
resource "aws_s3_bucket" "bronze_bucket" {
  bucket = "cris-utilidades-bronze"
}

resource "aws_s3_bucket" "silver_bucket" {
  bucket = "cris-utilidades-silver"
}

resource "aws_s3_bucket" "gold_bucket" {
  bucket = "cris-utilidades-gold"
}