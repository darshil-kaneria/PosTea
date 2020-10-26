
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getTopicFollowers(message.topic_id, connection);
          connection.release();
          process.send({"Topic Followers retrieved": "success"});
          process.exit();
          
        });
});

const getTopicFollowers = async(topic_id, connection) => {
    var query = "SELECT * FROM topic_follower WHERE topic_follower.topic_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[topic_id],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("Topic followers record does not exist");
            } else {
                console.log("Topic Followers retrieved");
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
