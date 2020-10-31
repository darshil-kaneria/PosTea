const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(async function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    deleteTopic(message.topic_id, message.user_id, connection).then(function(answer) {
      connection.release();
      if (answer == "Topic does not exist") {
        process.send({"Error": "Topic does not exist"});
      } else if (answer == "Success") {
            process.send({"Success": "Topic deleted"});
        }
        else {
            process.send(answer);
        }
      process.exit();
    });
    });
});

const deleteTopic = async(topic_id, user_id, connection) => {
    var selectQuery = "SELECT * FROM topic_info WHERE topic_id = ?";
    var deleteQuery = "DELETE FROM topic_info WHERE topic_id = ?";
    var deleteQuery2 = "DELETE FROM topic_follower WHERE topic_id = ?";
    var deleteQuery3 = "DELETE FROM topic_content WHERE topic_id = ?";

    return new Promise(function(resolve, reject) {
        connection.query(selectQuery,[topic_id],  async function (err, result) {
            if (err) {
                reject(err.message);
            }
            try {
                if (result.length == 0) {
                    resolve("Topic does not exist");
                } else if (result[0].topic_creator_id != user_id) {
                    resolve("Error: Topic cannot be deleted by other users")
                } else {
                    connection.query(deleteQuery, [topic_id], function(err, result) {
                        if (err) {
                            console.log(err);
                            reject(err.message);
                        } else {
                            connection.query(deleteQuery2, [topic_id], function(err, result) {
                                if (err) {
                                    console.log(err);
                                    reject(err.message);
                                } else {
                                    connection.query(deleteQuery3, [topic_id], function(err, result) {
                                        if (err) {
                                            console.log(err);
                                            reject(err.message);
                                        } else {
                                            resolve("Success");
                                        }
                                    });
                                }
                            });
                        }
                    }
                 );   
                }
            } catch (error) {
                reject(err.message);
            }
            resolve(result);

        }
        );

    })
}
