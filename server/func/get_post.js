
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getPost(message.post_id, connection).then((answer)=> {
            connection.release();
            process.send(answer);
            process.exit();
          });
          
          
        });
});

const getPost = async(postId, connection) => {
    var query = "SELECT * FROM user_post WHERE user_post.post_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[postId],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("Post does not exist");
            } else {
                console.log("Post retrieved");
                if (result[0].is_anonymous == 1) {
                    result[0].profile_id = -1;
                }
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
