const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          add_comm_eng(message.postID, message.like, message.engag_id, connection);
           // console.log(answer.length);
            
        });
        
});

const add_comm_eng = async ( postID, likes, engagement_id, connection) => {
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