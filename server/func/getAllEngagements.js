const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getAllEngagements(message.profile_id, connection).then((result) => {
            process.send(result);
            connection.release();
            process.exit();
          }).catch((reject) => {
            process.send(reject);
            connection.release();
            process.exit();
          });
          
        });
});

const getAllEngagements = async (profile_id, connection) => {
    var engagementQuery = "SELECT * FROM engagement WHERE engagement.profile_id = " + String(profile_id);
    var postQuery = "SELECT * FROM user_post as u, profile as p, topic_info as t WHERE u.profile_id=p.profile_id AND u.topic_id = t.topic_id AND u.post_id in ";
    
    return new Promise(async (resolve, reject) => {
        await connection.query(engagementQuery, async (err, result) => {
            if (err) {
                console.log("ERROR /getAllEngagements: " + err.message);
                reject(err.message);
            }
            result = JSON.stringify(result);
            result = JSON.parse(result);
            
            if(result.length == 0){
                resolve("No engagements");
            }
            else{
                var postIDs = "(";
                for (var i = 0; i < result.length; i++) {
                    if (i == result.length - 1) {
                        postIDs = postIDs + String(result[i]['post_id']) + ") ORDER BY u.creation_date DESC";
                    } else {
                        postIDs = postIDs + String(result[i]['post_id']) + ", ";
                    }
                }
                console.log("postIDs " + postIDs);
                
                postQuery = postQuery + postIDs;
                await connection.query(postQuery, (err, result) => {
                    if (err) {
                        console.log("ERROR /getAllEngagements: " + err.message);
                        reject(err.message);
                    }
                    result = JSON.stringify(result);
                    result = JSON.parse(result);

                    resolve(result);
                });
            }
            
        });
    });
}