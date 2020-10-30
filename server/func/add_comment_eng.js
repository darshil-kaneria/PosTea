const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          console.log("connection");
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          var data = {
            post_id: message.postID,
            like_or_dislike: message.like_or_dislike,
            engagement_id: message.engagement_id,
          }
          console.log(data);
          add_comm_eng(data, connection).then((answer) => {
            connection.release();
            if (answer == "engagement does not exist") {
                process.send({"Error": "engagement does not exist"});
            } else if (answer == "post does not exist") {
                process.send({"Error": "post does not exist"});

            
            } else {
                //console.log("sucsess");
                process.send(answer);
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
    var like = data.like_or_dislike;
    var engagement_id = data.engagement_id;
    //console.log(postID);

    

    var id = Math.floor(Math.random() * 100000);
    console.log(postID);
    //var addquery = "INSERT INTO comm_engagement (comm_id, post_id, comm_like, engagement_id) VALUES ?";
    var selectquery = "SELECT * FROM comm_engement WHERE engagement_id = ? AND post_id = ?" ;
    var updateQuery1 = "UPDATE comm_engagement SET comm_like = comm_like + 1 WHERE engagement_id = ? and post_id = ?";
    var updateQuery0 = "UPDATE comm_engagement SET comm_like = comm_like - 1 WHERE engagement_id = ? and post_id = ?";
    //var selectpost = "SELECT * FROM user_post WHERE post_id = ?";
    //var vals = [[id, postID,likes, engagement_id]];

    return new Promise(async function(resolve, reject) {
        await connection.query(selectquery,[engagement_id, postID],  async function (err, result) {
            if (err) {
                reject (err.message);
            } else {
                //console.log("executed");
                if (result.length == 0) {
                    resolve("engagement and post does not exist");
                console.log()
                } else {
                    if (like == 1) {
                        await connection.query(updateQuery1, [engagement_id, postID], async function (err, result) {
                            if (err) {
                                reject (err.message);
                            }
                            resolve(result);
                        });

                    } else {
                        await connection.query(updateQuery0, [engagement_id, postID], async function (err, result) {
                            if (err) {
                                reject (err.message);
                            }
                            resolve(result);
                        });
                    }
                    

                    /*
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
                                        resolve(result);
                                    }
                                });

                            }
                        }
                    });
                    */
                }

            }
        })
    });






}
