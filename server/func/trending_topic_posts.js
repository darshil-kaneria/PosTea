const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }

        getTrendingTopicPost(message, connection).then((answer) => {
            connection.release();
            console.log("Exiting process: " + process.pid);
            process.send({ "result": answer });
            process.exit();
        }).catch((err) => {
            connection.release();
            process.send({ "result": err.message });
            process.exit();
        });
    });
});

getTrendingTopicPost = async (message, connection) => {
    return new Promise(async (resolve, reject) => {
        var redis = db.redis_conn.createClient(process.env.REDISCLOUD_URL, { no_ready_check: true });
        var curr_date = new Date()
        var printDate = curr_date.toISOString().slice(0, 19).replace('T', ' ');
        curr_date.setHours(curr_date.getHours() - 20);
        printDate = curr_date.toISOString().slice(0, 19).replace('T', ' ');
        var tempDate = "2020-10-06 20:23:29";
        printDate = tempDate;
        // var getPostsLastHour = `select ti.topic_name, u.topic_id, count(u.topic_id) as post_count from user_post as u, topic_info as ti where u.creation_date >= "${printDate}" and ti.topic_id = u.topic_id GROUP BY topic_id order by post_count desc`;
        var getEngWithTopic = `select * from engagement e2, user_post up where topic_id = ${message.topic_id} and e2.creation_date >= "${printDate}" and e2.post_id = up.post_id`;
        await connection.query({ sql: getEngWithTopic, timeout: 120000 }, async (err, result) => {
            if(err){
                reject(err);
            }
            else{
                result = JSON.stringify(result);
                result = JSON.parse(result);
                
                if(result.length == 0){
                    resolve("empty");
                }
                var postIdList = [];
                for (var i = 0; i < result.length; i++) {
                    postIdList.push(result[i]['post_id']);
                }
                var counts = {};

                for (var i = 0; i < postIdList.length; i++) {
                    var num = postIdList[i];
                    counts[num] = counts[num] ? counts[num] + 1 : 1;
                }
                var sortable = [];
                for (var key in counts) {
                    sortable.push([key, counts[key]]);
                }
                sortable.sort(function(a, b) {
                    return a[1] - b[1];
                }).reverse();
                console.log(sortable);
                result[0] = sortable;
                resolve(result)
            }
        });
    });
}