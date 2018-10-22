package com.serverless;

import java.util.Collections;
import java.util.Map;
import java.util.HashMap;
import org.apache.log4j.Logger;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class Handler implements RequestHandler<Map<String, Object>, ApiGatewayResponse> {

	private static final Logger LOG = Logger.getLogger(Handler.class);

	@Override
	public ApiGatewayResponse handleRequest(Map<String, Object> input, Context context) {
		LOG.info("received: " + input);

		// final int N = 512;
		int N = System.getenv("NNN");
		double A[] = new double [N*N];
		double B[] = new double [N*N]; 
		double C[] = new double [N*N];

		for(int k=0;k<N*N;k++){
			A[k] = k;
			B[k] = k;
			C[k] = k;
		} 

		for(int w=0;w<N;w++){
			for(int h=0;h<N;h++){
				double tmp = 0;
				for(int k=0;k<N;k++){
					tmp = tmp + A[k+h*N] * B[w+k*N];
				}
				C[w+h*N] = tmp;
			}
		}
		// HashMap<String, String> output = new HashMap<String, >();
		// output.put("message","serverless java");
		// output.put("value", new Double(C[0]+C[N*N-1]));
		input.put("NNN", N));
		input.put("value", C[0]+C[C[N*N-1]%100]);
		Response responseBody = new Response("Go Serverless v1.x! Your function executed successfully!", output);
		return ApiGatewayResponse.builder()
				.setStatusCode(200)
				.setObjectBody(responseBody)
				.setHeaders(Collections.singletonMap("X-Powered-By", "AWS Lambda & serverless"))
				.build();
	}
}
