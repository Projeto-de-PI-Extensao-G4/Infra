output "buckets_datalake" {
  description = "Buckets do datalake por camada"
  value       = var.buckets_datalake
}

output "bucket_imagens" {
  description = "Bucket de imagens e comprovantes do backend"
  value       = var.bucket_imagens
}

# Pronto para colar no .env do backend. As credenciais NAO entram no .env:
# o SDK le do ~/.aws/credentials (no lab, com o aws_session_token).
output "backend_env" {
  description = "Variaveis de S3 para o .env do backend"
  value = join("\n", [
    "AWS_S3_ENDPOINT=",
    "AWS_S3_BUCKET=${var.bucket_imagens}",
    "AWS_S3_URL_BASE=https://${var.bucket_imagens}.s3.${local.regiao_s3}.amazonaws.com",
    "AWS_REGION=${local.regiao_s3}",
  ])
}
