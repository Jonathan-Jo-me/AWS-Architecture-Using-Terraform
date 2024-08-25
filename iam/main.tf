# Create IAM user
resource "aws_iam_user" "clops_user" {
  name = var.iam_user_name
}

# Attach S3 full access policy to IAM user
resource "aws_iam_user_policy_attachment" "clops_user_s3_full_access" {
  user       = aws_iam_user.clops_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


/*#  create an access key for the IAM user
resource "aws_iam_access_key" "clops_user_access_key" {
  user = aws_iam_user.clops_user.name
}*/
