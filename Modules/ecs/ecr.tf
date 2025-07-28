# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# ECR Repo. 
resource "aws_ecr_repository" "poc_ecr" {
  name                 = "poc_ecr"
  image_tag_mutability = "MUTABLE"

  force_delete         = true # 👈 This allows deletion even if images exist !!! Make sure if you do not want to deleting teh img while destroying infra!{}{}!
}