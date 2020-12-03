
const { json } = require('express');
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error:' + err.message);
          }
          console.log('Database connection established');
          if (message.flag == "following_count" || message.flag == "following_list") {
          getFollowing(message.profile_id, connection).then((value)=> {
              if (message.flag == "following_list") {
                process.send(value);
              } else if (message.flag == "following_count") {
                  var followingCount = {
                    "followingCount": value.length
                  };
                  followingCount = JSON.stringify(followingCount);
                  followingCount = JSON.parse(followingCount);
                process.send(followingCount);
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
                    var followerCount = {
                        "followerCount": answer.length
                      };
                    followerCount = JSON.stringify(followerCount);
                    followerCount = JSON.parse(followerCount);
                    process.send(followerCount);
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
    return new Promise(async function(resolve, reject) {
        await connection.query(query,[profile_id], async function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                reject("User following record does not exist");
            } else {
                result = JSON.stringify(result);
                result = JSON.parse(result);
                await convert_to_id_and_name("following", user_id, result, connection).then((value)=> {
                    result = value;
                    if (result == "Requested relationship does not exist.") {
                        reject("User following record does not exist");
                    }
                });
                console.log("Following retrieved");
                resolve(result);
                // return result;  
            }
        });
    });
}

const getFollowers = async(user_id, connection) => {
    var follower_id = user_id;
    var query = "SELECT * FROM user_follower WHERE user_follower.follower_id = ?";
    return new Promise(async function(resolve, reject) {
       await connection.query(query,[follower_id], async function(err, result)  {
            if (err) {
                console.log("error exists");
                //console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                reject("User followers record does not exist");
            } else {
                result = JSON.stringify(result);
                result = JSON.parse(result);
                console.log(result);
                await convert_to_id_and_name("followers", user_id, result, connection).then((value)=> {
                    result = value;
                    if (result == "Requested relationship does not exist.") {
                        reject("User followers record does not exist");
                    }
                });
                console.log("Followers retrieved");
                resolve(result);
                // return result;  
            }
        });
    });
}

const convert_to_id_and_name = async(flag, current_user, ids, connection) => {
    var query1 = "SELECT profile_id, name, username FROM profile WHERE";
    var profile_ids = [];
    if (flag == "following") {
        for (var i = 0; i < ids.length; i++) {
            if (current_user != ids[i].follower_id) {
                profile_ids.push(ids[i].follower_id);
                query1 = query1.concat(" profile.profile_id = ? OR");
            }
        }
    } else if (flag == "followers") {
        for (var i = 0; i < ids.length; i++) {
            if (current_user != ids[i].profile_id) {
                profile_ids.push(ids[i].profile_id);
                query1 = query1.concat(" profile.profile_id = ? OR");
            }
        }
    }
    
    query1 = query1.substr(0, query1.length-2);
    console.log(query1);
    if (profile_ids.length == 0) {
        return "Requested relationship does not exist.";
    }
    console.log(profile_ids);
    return new Promise(function(resolve, reject) {
       connection.query(query1,profile_ids,function(err, result)  {
            if (err) {
                console.log("error exists");
                reject(err.message);
            }
            else {
                result = JSON.stringify(result);
                result = JSON.parse(result);
                resolve(result);
                // return result;  
            }
        });
    });
}