const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    deletePost(message.postId, message.profileId, connection).then(function(answer) {
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

function deletePost(postId, profileId) {
    var p_id = postId;
    var prof = profileId;
    var selectfromPost = "SELECT * FROM user_post WHERE postId = ? AND profileId = ?";
    //var selectfromTop = "SELECT * FROM topic_content WHERE postId = ?";
    var deletefromPost = "DELETE FROM user_post WHERE postId = ?"
    var deletefromtopic = "DELETE FROM topic_content WHERE postId = ?"
    return new Promise(function(resolve, reject) {
        connection.query(selectfromPost,[p_id, prof],  function (err, result) {
            if (err) {
                console.log(err);
                throw err;
            }
            try {
                if (result.length == 0) {
                    resolve("Post does not exist");
                } else {
                    connection.query(deletefromPost, [p_id], function(err, result) {
                        console.log(err);
                        throw err;
                    }
                    );
                    connection.query(deletefromtopic, [p_id], function(err, result) {
                        if (err) {
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