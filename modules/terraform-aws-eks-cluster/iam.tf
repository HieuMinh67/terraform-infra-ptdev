data "aws_iam_policy_document" "bean" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = [
        "eks.amazonaws.com"
      ]

      type = "Service"
    }
  }
}

resource "aws_iam_role" "bean" {
  assume_role_policy    = data.aws_iam_policy_document.bean.json
  force_detach_policies = true
  name                  = local.cluster_name
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.bean.name
}

resource "aws_iam_role_policy_attachment" "service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.bean.name
}
