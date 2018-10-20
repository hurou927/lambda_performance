'use strict';

const AWS = require('aws-sdk');

const createResponse = (statusCode, body) => {
  return {
    statusCode: statusCode,
    body: JSON.stringify(body),
  }
}

module.exports.matmul = async (event, context) => {
  // console.log('event', event)
  // console.log('context', context)
  try {
    
    const N = 512

    const A = new Float64Array(N*N);
    const B = new Float64Array(N*N);
    const C = new Float64Array(N*N);
    for(let k=0;k<N*N;k++){
      A[k]=k;
      B[k]=k;
    }

    for(let w=0;w<N;w++){
      for(let h=0;h<N;h++){
        let tmp = 0;
        let index_a = h*N;
        let index_b = w;
        for(let k=0;k<N;k++){
          tmp = tmp + A[index_a] * B[index_b];
          index_a = index_a + 1;
          index_b = index_b + N;
        }
        C[w + h*N] = tmp;
      }
    }

    return createResponse(200,{
      message: 'OK',
      value: C[0]+C[N*N-1]
    })

  } catch (error) {
    
    return createResponse(400,{
      message: 'NG',
      error: {
        message: `error:${error}`,
        code : 100
      }
    });

  }
};

const S3 = new AWS.S3();
module.exports.s3access = async (event, context) => {
  // console.log('event', event)
  // console.log('context', context)
  try {
    
    const param = {
      Bucket: "readperformance", 
      Key: "s3image2k.tif"
    };
    const image = await S3.getObject(param).promise();

    return createResponse(200,{
      message: 'OK',
      value: image.ContentLength
    })

  } catch (error) {
    
    return createResponse(400,{
      message: 'NG',
      error: {
        message: `error:${error}`,
        code : 100
      }
    });

  }
}