const handler = require(__dirname + '/../src/main');

(async()=>{
    try{
        console.log(await handler.s3access({}, {}));
    }catch(error){
        console.log(error);
    }
})()
