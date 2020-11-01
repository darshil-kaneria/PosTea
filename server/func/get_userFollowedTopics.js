
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
        console.log('Database connection established');
        getTopicsFollowed(message.user_id, connection).then((result) => {
            var flag = message.flag;
            if (result == "User does not follow topics") {
                if (flag == "topic_count") {
                    process.send({"Topic followed": 0});
                } else if (flag == "topic_list") {
                    process.send(result);
                }
            } else {
                if (flag == "topic_count") {
                    process.send({"Topic followed": result.length});
                } else if (flag == "topic_list")  {
                    process.send(result);
                }
            }
            connection.release();
            process.exit();
          })
        });
});

const getTopicsFollowed = async(user_id, connection) => {
    var query = "SELECT * FROM topic_follower WHERE topic_follower.follower_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[user_id],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                resolve("User does not follow topics");
            } else {
                console.log("Topic list followed by user retrieved");
                resolve(result);
                // return result;  
            }
        });
    });
}
