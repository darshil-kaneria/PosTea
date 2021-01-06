const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }

        getTrendingTopic(message, connection).then((answer) => {
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

getTrendingTopic = async (message, connection) => {
    return new Promise(async (resolve, reject) => {
        var redis = db.redis_conn.createClient(process.env.REDISCLOUD_URL, { no_ready_check: true });
        var curr_date = new Date()
        var printDate = curr_date.toISOString().slice(0, 19).replace('T', ' ');
        curr_date.setHours(curr_date.getHours() - 8);
        printDate = curr_date.toISOString().slice(0, 19).replace('T', ' ');
        var tempDate = "2020-11-17 21:04:35";
        // printDate = tempDate;
        var getPostsLastHour = `select ti.topic_name, u.topic_id, count(u.topic_id) as post_count from user_post as u, topic_info as ti where u.creation_date >= "${printDate}" and ti.topic_id = u.topic_id GROUP BY topic_id order by post_count desc`;
        await connection.query({ sql: getPostsLastHour, timeout: 120000 }, async (err, result) => {
            if(err){
                reject(err);
            }
            else{
                result = JSON.stringify(result);
                result = JSON.parse(result);
                console.log(result);
                resolve(result)
            }
        });
    });
}