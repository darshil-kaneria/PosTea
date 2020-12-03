
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function (err, connection) {
        if (err) {
            return console.error('error: ' + err.message);
        }
        console.log('Database connection established');
        await getTopics(message.profile_id, connection).then((result) => {
            process.send(result);
            connection.release();
            process.exit();
        }).catch((reject) => {
            process.send(reject);
            connection.release();
            process.exit();
        });

    });
});

const getTopics = async (profile_id, connection) => {
    var query = "SELECT * FROM topic_follower WHERE topic_follower.follower_id = " + String(profile_id);
    var query2 = "SELECT topic_id, topic_name FROM topic_info WHERE topic_id in ";
    var topicIDs = [];
    return new Promise(function (resolve, reject) {
        connection.query(query, async function (err, result) {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("No topics followed by this user");
                reject("No topics followed by this user");
            } else {
                console.log("Topic Data retrieved");
                //console.log(result);
                result = JSON.stringify(result);
                result = JSON.parse(result);
                console.log(result);

                var topicIDString = "(";
                for (var i = 0; i < result.length; i++) {
                    if (i != result.length - 1) {
                        topicIDString = topicIDString + String(result[i]['topic_id']) + ", ";
                    } else {
                        topicIDString = topicIDString + String(result[i]['topic_id']) + ")";
                    }
                }

                query2 = query2 + topicIDString;
                await connection.query(query2, (err, result) => {
                    if (err) {
                        reject(err.message);
                    }

                    result = JSON.stringify(result);
                    result = JSON.parse(result);

                    console.log("Topic names are " + String(result));
                    resolve(result);
                })

                // return result;  
            }
        });
    });
}
