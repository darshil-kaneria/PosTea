
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          getFollowing(message.user_id, connection).then((value)=> {
            process.send(value, );
            connection.release();
        //process.send(resul);
              process.exit();
        
            }).catch(function(result) {
                process.send(result);
                connection.release();
                process.exit();

            });
          
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
                reject("User following record does not exist");
            } else {
                console.log("Following retrieved");
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
