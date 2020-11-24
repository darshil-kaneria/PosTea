
const { json } = require('express');
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getUserInfo(message.profile_id, connection).then((result) => {
            connection.release();
            process.send(result);
            process.exit();
          }).catch((reject) => {
            connection.release();
            process.send(reject);
            process.exit();
          });
          
        });
});

const getUserInfo = async(profile_id, connection) => {
    var getTopicIDs = "SELECT topic_id FROM topic_info WHERE topic_info.topic_creator_id = " + String(profile_id);
    var getPostIDs = "SELECT post_id FROM user_post WHERE user_post.profile_id = " + String(profile_id);
    var getEngagementInfo = "SELECT * FROM engagement WHERE engagement.profile_id = " + String(profile_id);
    var finalResult = {};
    return new Promise(function(resolve, reject) {
       connection.query(getTopicIDs, function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("Topic does not exist");
                reject("Topic does not exist");
            } else {
                console.log("Topic retrieved");
                //console.log(result);
                result = JSON.stringify(result);
                result = JSON.parse(result);
                console.log("Topic IDs are " + String(result));
                topicIDList = [];
                for (var i = 0; i < result.length; i++) {
                    topicIDList.push(result[i]['topic_id'])
                }
                console.log("topic id list is " + String(topicIDList));
                finalResult["topicIDs"] = topicIDList;
                
                connection.query(getPostIDs, (err, result2) => {
                    if (err) {
                        console.log("err is " + err.message);
                        reject(err);
                    }
                    
                    result2 = JSON.stringify(result2);
                    result2 = JSON.parse(result2);
                    var postIDList = [];
                    for (var i = 0; i < result.length; i++) {
                        postIDList.push(result[i]['topic_id'])
                    }

                    console.log("postIDs are " + String(result2));
                    finalResult["postIDs"] = postIDList;

                    connection.query(getEngagementInfo, (err, result3) => {
                        if (err) {
                            console.log("err is " + err.message);
                            reject(err.message);
                        }

                        result3 = JSON.stringify(result3);
                        result3 = JSON.parse(result3);

                        console.log("engagement info is " + String(result3));
                        finalResult["engagementInfo"] = result3;
                        resolve(finalResult);
                    });
                    
                });
                // return result;  
            }
        });
    });
}
