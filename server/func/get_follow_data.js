
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          if (message.flag == "following_count" || message.flag == "following_list") {
          getFollowing(message.profile_id, connection).then((value)=> {
              if (message.flag == "following_list") {
                process.send(value);
              } else if (message.flag == "following_count") {
                process.send({"following count": value.length});
              }
                connection.release();
                process.exit();
            }).catch(function(result) {
                process.send(result);
                connection.release();
                process.exit();

            });
        } else if (message.flag == "follower_list" || message.flag == "follower_count") {
            await getFollowers(message.profile_id, connection).then(function(answer) {
                if (message.flag == "follower_list") {
                    process.send(answer);
                  } else if (message.flag == "follower_count") {
                    process.send({"follower count": answer.length});
                }
                connection.release();
                process.exit();
              }).catch(function(result) {
                  process.send(result);
                  connection.release();
                  process.exit();
              });     
        }
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

const getFollowers = async(user_id, connection) => {
    var follower_id = user_id;
    var query = "SELECT * FROM user_follower WHERE user_follower.follower_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[follower_id],function(err, result)  {
            if (err) {
                console.log("error exists");
                //console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                reject("does not exist");
                //resolve(result);
            } else {
                console.log("Followers retrieved");
                //console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
