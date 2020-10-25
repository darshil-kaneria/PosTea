
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getTopicsFollowed(message.user_id, connection);
          connection.release();
          process.send({"Topic Followers retrieved": "success"});
          process.exit();
          
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
                console.log("User does not follow topics");
            } else {
                console.log("Topic list followed by user retrieved");
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
