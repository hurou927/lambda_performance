package main

import (
	// "bytes"
	"context"
	"encoding/json"
	// "fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Response is of type APIGatewayProxyResponse since we're leveraging the
// AWS Lambda Proxy Request functionality (default behavior)
//
// https://serverless.com/framework/docs/providers/aws/events/apigateway/#lambda-proxy-integration
type Response events.APIGatewayProxyResponse

const N int = 512

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


func Handler(ctx context.Context) (Response, error) {

	// fmt.Print("Hello");
	
	A := [N*N] float64 {};
	B := [N*N] float64 {};
	C := [N*N] float64 {};
	for k := 0; k < N*N; k++ {
		A[k] = float64(k)
		B[k] = float64(k)
	}
	for w := 0; w < N; w++ {
		for h := 0; h < N ; h++ {
			var tmp float64 = 0.0
			for k := 0; k < N ; k++ {
				tmp = tmp + A[k+h*N] * B[w+k*N]
			}
			C[w+h*N] = tmp
		}
	}
	resp, resErr := createResponse(200, map[string]interface{}{
		"message": "Go Serverless v1.0! Your function executed successfully!",
		"value": C[0]+C[N*N-1],
	})

	return resp, resErr
}

func main() {
	lambda.Start(Handler)
}
