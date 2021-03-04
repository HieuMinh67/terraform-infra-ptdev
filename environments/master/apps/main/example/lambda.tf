variable "lambda_function_name" {
  default = "lambda_function_name"
}
# EFS access point used by lambda file system
resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = aws_efs_file_system.efs_for_lambda.id

  root_directory {
    path = "/lambda"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "777"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}


# EFS file system
resource "aws_efs_file_system" "efs_for_lambda" {
}

# Mount target connects the file system to the subnet
resource "aws_efs_mount_target" "alpha" {
  file_system_id  = aws_efs_file_system.efs_for_lambda.id
  subnet_id       = aws_subnet.subnet_for_lambda.id
  security_groups = [aws_security_group.sg_for_lambda.id]
}

resource "aws_subnet" "subnet_for_lambda" {
  vpc_id     = aws_vpc.vpc_for_lambda.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_vpc" "vpc_for_lambda" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_security_group" "sg_for_lambda" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_for_lambda.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_for_lambda.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": 
 "sts:AssumeRole"
      ,

      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_s3_bucket_object" "mylambdacode" {
  bucket = "479284709538-${var.aws_region}-aws-lambda"
  key    = "terraform-api/hello.zip"
}

resource "aws_lambda_function" "test_lambda" {
  s3_bucket     = "479284709538-${var.aws_region}-aws-lambda"
  s3_key        = "terraform-api/hello.zip"
  function_name = "hellotfc"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.aws_s3_bucket_object.mylambdacode.etag

  runtime = "provided"

  environment {
    variables = {
      foo = "bar"
    }
  }

  file_system_config {
    # EFS file system access point ARN
    arn = aws_efs_access_point.access_point_for_lambda.arn

    # Local mount path inside the lambda function. Must start with '/mnt/'.
    local_mount_path = "/mnt/efs"
  }

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.subnet_for_lambda.id]
    security_group_ids = [aws_security_group.sg_for_lambda.id]
  }

  # Explicitly declare dependency on EFS mount target.
  # When creating or updating Lambda functions, mount target must be in 'available' lifecycle state.
  depends_on = [
    aws_efs_mount_target.alpha,
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example
  ]

}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

