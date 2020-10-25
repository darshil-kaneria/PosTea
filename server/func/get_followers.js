
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getFollowers(message.user_id, connection).then(function(answer) {
            connection.release();
            process.exit();
      });     
    });
});

const getFollowers = async(user_id, connection) => {
    var follower_id = user_id;
    var query = "SELECT * FROM user_follower WHERE user_follower.follower_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[follower_id],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("User followers record does not exist");
            } else {
                console.log("Followers retrieved");
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
