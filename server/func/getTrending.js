const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }

        getTrending(message, connection).then((answer) => {
            connection.release();
            console.log("Exiting process: "+process.pid);
            process.send({"result": answer});
            process.exit();
        }).catch((err) => {
            connection.release();
            process.send({"result": err.message});
            process.exit();
        });
    });
});

getTrending = async (message, connection) => {
    
    return new Promise(async (resolve, reject)=>{
        var redis = db.redis_conn.createClient(process.env.REDISCLOUD_URL, {no_ready_check: true});
        var curr_date = new Date()
        var printDate = curr_date.toISOString().slice(0, 19).replace('T', ' ');
        curr_date.setHours(curr_date.getHours()-3);
        printDate = curr_date.toISOString().slice(0, 19).replace('T', ' ');
        // replace hardcode with printDate
        var getEngLastHour = `select e.engagement_id, e.post_id, e.profile_id, e.like_or_dislike, e.comment, e.creation_date, p.is_private from engagement e join profile p where e.profile_id = p.profile_id and p.is_private != 1 and e.creation_date >= '${printDate}'`;
        await connection.query({sql: getEngLastHour, timeout: 120000}, async (err, result) => {
            if(err){
                reject(err.message);
            }
            // Calculate total engagements per post
            result = JSON.stringify(result);
            result = JSON.parse(result);
            var postIdList = [];
            for (var i= 0; i < result.length; i++){
                if(!postIdList.includes(result[i]['post_id'])){
                    postIdList.push(result[i]['post_id']);
                }
                
            }
            var totalEngPerPost = {};
            var totalLikeCount = 0;
            var finalList = []
            for (var i = 0; i < postIdList.length; i++){
                var likeCount = 0;
                var dislikeCount = 0;
                var commentCount = 0;
                var totalCountPerPost = 0;

                for(var j=0; j < result.length; j++){
                    if(result[j]['post_id'] == postIdList[i]){
                        if(result[j]['like_or_dislike'] != null){

                            if(result[j]['like_or_dislike'] == 1){
                                likeCount++;
                                totalCountPerPost++;
                            }
                            else if(result[j]['like_or_dislike'] == 0){
                                dislikeCount++;
                                totalCountPerPost++;
                            }

                        }
                        
                        if(result[j]['comment']!=null){
                            commentCount++;
                            totalCountPerPost++;
                        }
                    }
                }
                totalEngPerPost[postIdList[i]] = {
                    "likeCount": likeCount,
                    "dislikeCount": dislikeCount,
                    "commentCount": commentCount,
                    "totalCountPerPost": totalCountPerPost
                }
                var ratio = 0.0
                try{
                    ratio = totalEngPerPost[postIdList[i]]['likeCount']/totalEngPerPost[postIdList[i]]['dislikeCount'];
                    if(isNaN(ratio)){
                        throw "isNan";
                    }
                    else if(!isFinite(ratio)){
                        ratio = totalEngPerPost[postIdList[i]]['likeCount'];
                    }
                }
                catch(e){
                    console.log(e);
                    ratio = -1;
                }
                finalList.push({
                    "postId": postIdList[i],
                    "ratio": ratio,
                    "totalCountPerPost": totalCountPerPost
                });
            }
            finalList.sort((a, b) => (a.ratio >= b.ratio) && (a.totalCountPerPost >= b.totalCountPerPost) ? 1 : -1).reverse();
            console.log(finalList);
            finalListString = "";
            if(finalList.length == 1){
                finalListString = "("+finalList[0]+")";
            }
            else if(finalList.length > 1){

                for(var i = 0; i < finalList.length; i++){
                    if(i != finalList.length-1)
                        finalListString = finalListString.concat(finalList[i]['postId']+", ");
                    else
                        finalListString = finalListString.concat(finalList[i]['postId']+")");
                }

            }
            
            if(finalListString == ""){
                resolve("No_trending");
            }
            
            var query = `SELECT * FROM user_post as up, profile as p WHERE up.post_id in (${finalListString} and up.profile_id = p.profile_id ORDER BY FIELD(up.post_id, ${finalListString}`;
            await connection.query({sql: query, timeout: 120000}, (err, result) => {

                if(err){
                    reject(err);
                }
                redis.on("connect", function () {
                    console.log("Cache connection established");
                    resultString = JSON.stringify(result);
                    result = JSON.parse(resultString);
                    // console.log(result);
                    redis.set('posts', resultString);
                    // resolve(finalList);
                    // for(var i = 0; i < postIdList.length; i++){
                    //     redis.set(result[i]['post_id'], result[i].toString());
                    //     redis.get(result[i]['post_id'], (err, data) => {
                    //         console.log(data);
                    //     })
                    // }
                    // console.log("cache set");
                    resolve(finalList);
                })
                
            });

            
        })

    });
    
}