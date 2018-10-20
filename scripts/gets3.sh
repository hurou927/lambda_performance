getLeastLogStreamName(){
    aws logs describe-log-streams \
    --max-items 1 \
    --order-by LastEventTime \
    --descending  \
    --region ap-northeast-1 \
    --log-group-name /aws/lambda/$1 | jq -r '.logStreams[0].logStreamName'
}

N=40
memlist='00128 00256 00512 01024 01536 03008'
unixTime=$(printf '%ld' $(expr `date +%s%N` / 1000000))
apiPrefix='https://jmz57he8y3.execute-api.ap-northeast-1.amazonaws.com/dev/perf/s3get/'
lambdaPrefix='dev-generalTemp-lambda-lambdaPerformanceS3GetObjNodejs'


# echo $unixTime


# for m in $memlist; do
#     echo $m MB
#     for ((i=0;i<N;i++)); do
#         curl -s -X POST ${apiPrefix}$m | jq .
#     done
# done


unixTime=1540039314979
for m in $memlist; do
    lambda=$lambdaPrefix$m
    stname=$(getLeastLogStreamName $lambda)
    ms=$(aws logs get-log-events --region ap-northeast-1 --log-group-name /aws/lambda/$lambda --log-stream-name $stname --start-time $unixTime | grep Duration | sed -r 's/.*tDuration: (.*) ms\\t.*/\1/')
    echo $m MB $ms
done

# echo UNIXTIME,$unixTime

