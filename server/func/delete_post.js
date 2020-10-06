const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(async function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    await deletePost(message.deletePostID, message.deleteProfileID, connection).then(function(answer) {
      connection.release();
      if (answer == "Post does not exist") {
        process.send({"Error": "No account with that post or user exists"});
      } else {
        process.send({"Post deleted": "Successfully"});
      }
      process.exit();
  });
});
});

function deletePost(postId, profileId, connection) {
    var p_id = postId;
    var prof = profileId;
    var selectfromPost = "SELECT * FROM user_post WHERE post_id = ? AND profile_id = ?";
    //var selectfromTop = "SELECT * FROM topic_content WHERE postId = ?";
    var deletefromPost = "DELETE FROM user_post WHERE post_id = ?"
    var deletefromtopic = "DELETE FROM topic_content WHERE post_id = ?"
    return new Promise(async function(resolve, reject) {
        await connection.query(selectfromPost,[p_id, prof],  async function (err, result) {
            if (err) {
                console.log("hi");
                console.log(err);
                throw err;
            }
            try {
                if (result.length == 0) {
                    resolve("Post does not exist");
                } else {
                    await connection.query(deletefromPost, [p_id], function(err, result) {
                        if (err) {
                            console.log("hi2");
                            console.log(err);
                            throw err;
                        }
                        return result;
                    }
                    );
                    await connection.query(deletefromtopic, [p_id], function(err, result) {
                        if (err) {
                            console.log("hi3");
                            console.log(err);
                            throw err;
                        } else {
                            resolve("Post deleted");
                        }
                        
                    }
                    );
                    
                }

            } catch (error) {
                throw err;
            }
            return;

        }
        );

    })





}