# Conta do AWS Academy Learner Lab?
#
# true (padrao): os buckets sao criados pela AWS CLI. A service control policy
# do lab NEGA s3:GetBucketObjectLockConfiguration, e o provider da AWS faz essa
# leitura sempre que cria ou le um bucket. Resultado com recurso nativo: ele
# cria o bucket, falha na leitura, marca como tainted, e o apply seguinte
# APAGA e recria o bucket — com o datalake, perda de dados a cada apply.
#
# false: conta AWS comum, sem essa restricao. Usa os recursos nativos.
variable "learner_lab" {
  description = "true = AWS Academy Learner Lab (buckets pela AWS CLI); false = conta AWS comum (recursos nativos)"
  type        = bool
  default     = true
}

# Bucket das imagens de produto e dos comprovantes do backend.
# Tem que ser IGUAL ao AWS_S3_BUCKET do .env do backend.
variable "bucket_imagens" {
  description = "Bucket de imagens e comprovantes do backend"
  type        = string
  default     = "cris-utilidades-g4"
}

# Perfil IAM das instancias de backend. E dele que o DefaultCredentialsProvider
# do SDK tira a credencial do S3 — nenhuma chave vai para o .env do servidor.
# No Learner Lab so existe o LabInstanceProfile (o lab nao deixa criar role).
variable "perfil_instancia_backend" {
  description = "Instance profile das EC2 de backend (acesso ao S3)"
  type        = string
  default     = "LabInstanceProfile"
}

# Camada do datalake -> nome do bucket.
# Nome de bucket e unico no mundo inteiro: se um estiver ocupado, troque aqui.
variable "buckets_datalake" {
  description = "Buckets do datalake por camada"
  type        = map(string)
  default = {
    bronze = "cris-utilidades-analise-bronze"
    silver = "cris-utilidades-analise-silver"
    gold   = "cris-utilidades-analise-gold"
  }
}
