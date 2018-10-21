package main

import (
	// "bytes"
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Response is of type APIGatewayProxyResponse since we're leveraging the
// AWS Lambda Proxy Request functionality (default behavior)
//
// https://serverless.com/framework/docs/providers/aws/events/apigateway/#lambda-proxy-integration
type Response events.APIGatewayProxyResponse

const N int = 32

func createResponse(statusCode int, bodyMap map[string]interface{}) ( Response, error ) {
	
	bodyStr, err := json.Marshal(bodyMap);

	if err != nil {
		return Response{}, err
	}

	return Response{
		StatusCode: statusCode,
		IsBase64Encoded: false,
		Body:            string(bodyStr),
		Headers: map[string]string{
			"Content-Type":           "application/json",
			"X-MyCompany-Func-Reply": "hello-handler",
		},
	}, nil
}

// Handler is our lambda handler invoked by the `lambda.Start` function call
func Handler(ctx context.Context) (Response, error) {

	fmt.Print("Hello");

	resp, resErr := createResponse(200, map[string]interface{}{
		"message": "Go Serverless v1.0! Your function executed successfully!",
	})

	return resp, resErr
}

func main() {
	lambda.Start(Handler)
}
