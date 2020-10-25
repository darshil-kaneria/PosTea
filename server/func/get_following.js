
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getFollowing(message.user_id, connection);
          connection.release();
          process.send({"Following retrieved": "success"});
          process.exit();
          
        });
});

const getFollowing = async(user_id, connection) => {
    var profile_id = user_id;
    var query = "SELECT * FROM user_follower WHERE user_follower.profile_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[profile_id],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("User following record does not exist");
            } else {
                console.log("Following retrieved");
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
