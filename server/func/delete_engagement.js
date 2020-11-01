const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(async function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    await deleteEngagement(message.engagement_id, message.post_id, message.profile_id, message.like_or_dislike, message.comment, connection).then(function(answer) {
      connection.release();
      if (answer == "User-User relationship does not exist") {
        process.send({"Error": "User-User relationship does not exist"});
    } else if (answer == "Success") {
            process.send({"Success": "User Follower relationship deleted"});
        }
        else {
            process.send(answer);
        }
      process.exit();
    });
    });
});

function deleteEngagement(profile_id, follower_id, connection) {
    var selectQuery = "SELECT * FROM user_follower WHERE profile_id = ? AND follower_id = ?";
    var deleteQuery = "DELETE FROM user_follower WHERE profile_id = ? AND follower_id = ?"
    return new Promise(async function(resolve, reject) {
        await connection.query(selectQuery,[profile_id, follower_id],  async function (err, result) {
            if (err) {
                reject(err.message);
            }
            try {
                if (result.length == 0) {
                    resolve("User-User does not exist");
                } else {
                    await connection.query(deleteQuery, [profile_id, follower_id], function(err, result) {
                        if (err) {
                            console.log(err);
                            reject(err.message);
                        } else {
                            resolve("Success");
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
