#Criacao dos S3 para analise de dados
resource "aws_s3_bucket" "bronze_bucket" {
  bucket = "cris-utilidades-analise-bronze"
}

resource "aws_s3_bucket" "silver_bucket" {
  bucket = "cris-utilidades-analise-silver"
}

resource "aws_s3_bucket" "gold_bucket" {
  bucket = "cris-utilidades-analise-gold"
}

resource "aws_s3_bucket" "gold_bucket" {
  bucket = "cris-utilidades-bucket"
}