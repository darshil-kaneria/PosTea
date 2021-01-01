
const db = require('./db_connection.js');
var result;
process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getTopic(message.topic_id, connection).then((ans) => {
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

const getTopic = async(topic_id, connection) => {
    var query = "SELECT * FROM topic_info WHERE topic_info.topic_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[topic_id],function(err, result1)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result1.length == 0) {
                console.log("Topic does not exist");
                reject("Topic does not exist");
            } else {
                console.log("Topic retrieved");
                //console.log(result);
                result1 = JSON.stringify(result1);
                result1 = JSON.parse(result1);
                result = result1;
                // console.log(result1[0]['topic_creator_id']);
                var getCreatorName = "select name from profile where profile_id="+result1[0]['topic_creator_id'];
                connection.query(getCreatorName, function(err, result2){
                  if(err){
                    reject(err);
                  }
                  else{
                    result2 = JSON.stringify(result2);
                    result2 = JSON.parse(result2);
                    // console.log("creator name: "+result2[0]['name']);
                    result[0]['creator_name'] = result2[0]['name'];

                    var getFollowers = "select p.name from profile as p, topic_follower as tf where tf.topic_id = "+topic_id+" and tf.follower_id = p.profile_id";
                    connection.query(getFollowers, function(err, result3){
                      if(err){
                        reject(err);
                      }
                      else{
                        result3 = JSON.stringify(result3);
                        result3 = JSON.parse(result3);
                        
                        result[0]['followers'] = result3;

                        var getPostCount = "select count(*) from user_post where topic_id = "+topic_id;
                        connection.query(getPostCount, function(err, result4){
                          if(err){
                            reject(err);
                          }
                          else{
                            result4 = JSON.stringify(result4);
                            result4 = JSON.parse(result4);
                            
                            result[0]['post_count'] = result4[0]['count(*)'];
                            console.log(result);
                            resolve(result);
                          }
                        });
                      }
                    });
                  }
                });
                

                // return result;  
            }
        });
    });
}
