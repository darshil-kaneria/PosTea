const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          var data = {
            post_id: message.postID,
            likes: message.likes,
            engagement_id: message.engagement_id,
          }
          add_comm_eng(data, connection).then((answer) => {
            connection.release();
            if (answer == "engagement does not exist") {
                process.send({"Error": "engagement does not exist"});
            } else if (answer == "post does not exist") {
                process.send({"Error": "post does not exist"});

            
            } else if (answer == "comment addded") {
                console.log("sucsess");
                process.send({"Success": "comment engagement added"});
            }
            process.exit();
          }).catch(function(result) {
            process.send(result);
            connection.release();
            process.exit();


          }); ;


          
           // console.log(answer.length);

            
        });
        
});

const add_comm_eng = async ( data, connection) => {
    postID = data.post_id;
    var likes = data.likes;
    var engagement_id = data.engagement_id;
    //console.log(postID);

    

    var id = Math.floor(Math.random() * 100000);
    var addquery = "INSERT INTO comm_engagement (comm_id, post_id, comm_like, engagement_id) VALUES ?";
    var selectquery = "SELECT * FROM engagement WHERE engagement_id = ?" ;
    var selectpost = "SELECT * FROM user_post WHERE post_id = ?";
    var vals = [[id, postID,likes, engagement_id]];
    return new Promise(async function(resolve, reject) {
        await connection.query(selectquery,[engagement_id],  async function (err, result) {
            if (err) {
                reject (err.message);
            } else {
                //console.log("executed");
                if (result.length == 0) {
                    resolve("engagement does not exist");
                } else {
                    await connection.query(selectpost, [postID], async function (err, result) {
                        if (err) {
                            reject(err.message);
                        } else {
                            if (result.length == 0) {
                                resolve("post does not exit");
                            } else {
                                await connection.query(addquery, [vals], async function (err, result) {
                                    if (err) {
                                        reject(err.message);
                                    } else {
                                        resolve("comment added");
                                    }
                                });

                            }
                        }
                    });
                }

            }
        })
    });






}
