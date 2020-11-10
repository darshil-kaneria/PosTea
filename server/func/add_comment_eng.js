const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          console.log("connection");
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          add_comm_eng(message, connection).then((answer) => {
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
        });
        
});

const add_comm_eng = async ( data, connection) => {
    var postID = data.post_id;
    var like = data.comm_like;
    var engagement_id = data.engagement_id;
    

    

    var id = Math.floor(Math.random() * 100000);
    console.log(postID);
    var selectquery = "SELECT * FROM comm_engagement WHERE engagement_id=" + String(engagement_id) + " AND post_id=" + String(postID);
    var updateQuery1 = "UPDATE comm_engagement SET comm_like = comm_like + 1 WHERE engagement_id=" + String(engagement_id) + " AND post_id=" + String(postID);
    var updateQuery0 = "UPDATE comm_engagement SET comm_like = comm_like - 1 WHERE engagement_id=" + String(engagement_id) +" AND post_id=" + String(postID);

    console.log(like);
    return new Promise(async function(resolve, reject) {
        await connection.query(selectquery,  async function (err, result) {
            console.log(result);
            if (err) {
                console.log(err.message);
                reject (err.message);
            } else {
                if (result.length == 0) {
                    var ins_query = "INSERT INTO comm_engagement VALUES ?";
                    var val = [[id, postID, 1, engagement_id]];
                    await connection.query(ins_query, [val], async (err, result) => {
                        if(err){
                            reject(err.message);
                        }
                        resolve(result);
                    });
                
                } else {
                    console.log(like);
                    if (like == "1") {
                        await connection.query(updateQuery1, async function (err, result) {
                            if (err) {
                                reject (err.message);
                            }
                            resolve(result);
                        });

                    } else {
                        await connection.query(updateQuery0, async function (err, result) {
                            if (err) {
                                reject (err.message);
                            }
                            resolve(result);
                        });
                    }
                    
                }

            }
        })
    });






}
