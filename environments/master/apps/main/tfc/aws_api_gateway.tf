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

/*
The "REST API" is the container for all of the other API Gateway objects we will create.
All incoming requests to API Gateway must match with a configured resource and method in order to be handled. 
Append the following to define a single proxy resource:
*/
resource "aws_api_gateway_resource" "bean-proxy" {
   rest_api_id = aws_api_gateway_rest_api.bean-notification.id
   parent_id   = aws_api_gateway_rest_api.bean-notification.root_resource_id
   path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "bean-proxy" {
   rest_api_id   = aws_api_gateway_rest_api.bean-notification.id
   resource_id   = aws_api_gateway_resource.bean-proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

/*
The special path_part value "{proxy+}" activates proxy behavior, which means that this resource will match any request path. 
Similarly, the aws_api_gateway_method block uses a http_method of "ANY", which allows any request method to be used. 
Taken together, this means that all incoming requests will match this resource.
Each method on an API gateway resource has an integration which specifies where incoming requests are routed. 
Add the following configuration to specify that requests to this method should be sent to the Lambda function defined earlier:
*/
resource "aws_api_gateway_integration" "bean-notification" {
   rest_api_id = aws_api_gateway_rest_api.bean-notification.id
   resource_id = aws_api_gateway_method.bean-proxy.resource_id
   http_method = aws_api_gateway_method.bean-proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.bean-notification.invoke_arn
}
