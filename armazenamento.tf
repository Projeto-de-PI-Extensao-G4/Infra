# =========================================================
# S3 - DATALAKE (bronze, silver, gold) E IMAGENS DO BACKEND
# =========================================================
#
# Dois caminhos, escolhidos por var.learner_lab (ver variables.tf):
#   - learner_lab = true  -> AWS CLI, sem a leitura que a SCP do lab bloqueia
#   - learner_lab = false -> recursos nativos do Terraform
#
# Os dois criam a MESMA coisa:
#   - datalake: buckets privados, com todo acesso publico bloqueado
#   - imagens:  leitura publica SO em produtos/*; comprovantes/ continua
#               privado e e servido por URL pre-assinada pelo backend

locals {
  regiao_s3 = "us-east-1"

  # Espelha o que o S3ArmazenamentoService do backend assume: URL crua para
  # produtos/, URL assinada para comprovantes/. Abrir o bucket inteiro jogaria
  # a assinatura do comprovante no lixo.
  politica_imagens = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "LeituraPublicaProdutos"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::${var.bucket_imagens}/produtos/*"
    }]
  })
}

# ---------------------------------------------------------
# CONTA AWS COMUM (learner_lab = false)
# ---------------------------------------------------------

resource "aws_s3_bucket" "datalake" {
  for_each = var.learner_lab ? {} : var.buckets_datalake
  bucket   = each.value

  tags = {
    Name   = each.value
    Camada = each.key
  }
}

resource "aws_s3_bucket_public_access_block" "datalake" {
  for_each = aws_s3_bucket.datalake
  bucket   = each.value.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "imagens" {
  count  = var.learner_lab ? 0 : 1
  bucket = var.bucket_imagens

  tags = {
    Name = var.bucket_imagens
  }
}

# block_public_policy = false e o que permite a policy abaixo existir. Com o
# padrao da AWS (true), o apply passa e as imagens dao 403 no navegador.
resource "aws_s3_bucket_public_access_block" "imagens" {
  count  = var.learner_lab ? 0 : 1
  bucket = aws_s3_bucket.imagens[0].id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "imagens" {
  count      = var.learner_lab ? 0 : 1
  bucket     = aws_s3_bucket.imagens[0].id
  policy     = local.politica_imagens
  depends_on = [aws_s3_bucket_public_access_block.imagens]
}

# ---------------------------------------------------------
# AWS ACADEMY LEARNER LAB (learner_lab = true)
# ---------------------------------------------------------
# Todo comando e idempotente: rodar de novo nao apaga nem duplica nada.
# "head-bucket || create-bucket" so cria se o bucket ainda nao existir.
#
# O terraform destroy NAO apaga estes buckets, de proposito: datalake nao
# some por acidente. Ao fim da sessao, o proprio lab descarta os recursos.

resource "terraform_data" "datalake_cli" {
  for_each         = var.learner_lab ? var.buckets_datalake : {}
  triggers_replace = [each.value]

  provisioner "local-exec" {
    command = "aws s3api head-bucket --bucket ${each.value} --region ${local.regiao_s3} || aws s3api create-bucket --bucket ${each.value} --region ${local.regiao_s3}"
  }

  provisioner "local-exec" {
    command = "aws s3api put-public-access-block --bucket ${each.value} --region ${local.regiao_s3} --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
  }
}

# A policy vai por arquivo: passar JSON pela linha de comando exige aspas
# diferentes no cmd do Windows e no sh do Linux.
resource "local_file" "politica_imagens" {
  count    = var.learner_lab ? 1 : 0
  content  = local.politica_imagens
  filename = ".gerado/politica-imagens.json"
}

resource "terraform_data" "imagens_cli" {
  count            = var.learner_lab ? 1 : 0
  triggers_replace = [var.bucket_imagens, local.politica_imagens]

  provisioner "local-exec" {
    command = "aws s3api head-bucket --bucket ${var.bucket_imagens} --region ${local.regiao_s3} || aws s3api create-bucket --bucket ${var.bucket_imagens} --region ${local.regiao_s3}"
  }

  provisioner "local-exec" {
    command = "aws s3api put-public-access-block --bucket ${var.bucket_imagens} --region ${local.regiao_s3} --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"
  }

  # Caminho relativo de proposito: o cmd do Windows perde as aspas e quebra o
  # caminho absoluto no espaco de "3 semestre".
  provisioner "local-exec" {
    working_dir = path.module
    command     = "aws s3api put-bucket-policy --bucket ${var.bucket_imagens} --region ${local.regiao_s3} --policy file://${local_file.politica_imagens[0].filename}"
  }
}
