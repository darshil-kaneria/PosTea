const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(async function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    await deleteTopicFollower(message.topic_id, message.follower_id, connection).then(function(answer) {
      connection.release();
      if (answer == "User-Topic does not exist") {
        process.send({"Error": "User-Topic relationship does not exist"});
    } else {
            process.send({"Success": "Topic Follower relationship deleted"});
        }
      process.exit();
    });
    });
});

function deleteTopicFollower(topic_id, follower_id, connection) {
    var selectQuery = "SELECT * FROM topic_follower WHERE topic_id = ? AND follower_id = ?";
    var deleteQuery = "DELETE FROM topic_follower WHERE topic_id = ? AND follower_id = ?"
    return new Promise(async function(resolve, reject) {
        await connection.query(selectQuery,[topic_id, follower_id],  async function (err, result) {
            if (err) {
                reject(err.message);
            }
            try {
                if (result.length == 0) {
                    resolve("User-Topic does not exist");
                } else {
                    await connection.query(deleteQuery, [topic_id, follower_id], function(err, result) {
                        if (err) {
                            console.log(err);
                            reject(err.message);
                        }
                        resolve(result);
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
