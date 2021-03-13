/*
API Gateway's name reflects its original purpose as a public-facing frontend for REST APIs, 
but it was later extended with features that make it easy to expose an entire web application based on AWS Lambda. 
These later features will be used in this tutorial. The term "REST API" is thus used loosely here, 
since API Gateway is serving as a generic HTTP frontend rather than necessarily serving an API.

Create a new file aws_api_gateway.tf in the same directory as our lambda.tf from the previous step. First, configure the root "REST API" object, as follows:  
*/
resource "aws_api_gateway_rest_api" "bean-notification" {
  name        = "BeanNotificationApi"
  description = "AWS Serverless Application to handle TFE Api"
}
