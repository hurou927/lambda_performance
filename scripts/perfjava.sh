getLeastLogStreamName(){
    aws logs describe-log-streams \
    --max-items 1 \
    --order-by LastEventTime \
    --descending  \
    --region ap-northeast-1 \
    --log-group-name /aws/lambda/$1 | jq -r '.logStreams[0].logStreamName'
}

N=25
memlist='00128 00256 00512 01024 01536 03008'
unixTime=$(printf '%ld' $(expr `date +%s%N` / 1000000))
apiPrefix='https://1c7w6wwja4.execute-api.ap-northeast-1.amazonaws.com/dev/perf/matmul/'
lambdaPrefix='dev-generalTempJAVA-lambda-lambdaPerformanceMatmulJava'


# echo $unixTime


# for m in $memlist; do
#     echo $m MB
#     for ((i=0;i<N;i++)); do
#         echo $i
#         curl -s -X POST ${apiPrefix}$m | jq .
#         sleep 1
#     done
# done


unixTime=1540212349350
for m in $memlist; do
    lambda=$lambdaPrefix$m
    stname=$(getLeastLogStreamName $lambda)
    ms=$(aws logs get-log-events --region ap-northeast-1 --log-group-name /aws/lambda/$lambda --log-stream-name $stname --start-time $unixTime | grep Duration | sed -r 's/.*tDuration: (.*) ms\\t.*/\1/')
    echo $m MB $ms
done

echo UNIXTIME,$unixTime

