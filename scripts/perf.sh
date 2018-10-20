
getLeastLogStreamName(){
    aws logs describe-log-streams \
    --max-items 1 \
    --order-by LastEventTime \
    --descending   \
    --profile hurou \
    --log-group-name /aws/lambda/$1 | jq -r '.logStreams[0].logStreamName'
}

N=20
memlist='00128 00256 00512 01024 01536 03008'
unixTime=$(printf '%ld' $(expr `date +%s%N` / 1000000))
echo $unixTime

# for m in $memlist; do
#     echo $m MB
#     for ((i=0;i<N;i++)); do
#         curl -s -X POST https://b0tfiw44g5.execute-api.ap-northeast-1.amazonaws.com/dev/perf/$m | jq .
#     done
# done

unixTime=1539870789929
for m in $memlist; do
    lambda='dev-generalTemp-lambda-lambdaPerformanceNodejs'$m
    stname=$(getLeastLogStreamName $lambda)
    ms=$(aws logs get-log-events --profile hurou --log-group-name /aws/lambda/$lambda --log-stream-name $stname --start-time $unixTime | grep Duration | sed -r 's/.*tDuration: (.*) ms\\t.*/\1/')
    echo $m MB $ms
done


