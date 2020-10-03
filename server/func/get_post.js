
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          
          console.log('Database connection established');
          await getPost(message.userid, connection);
          connection.release();
          process.send({"post retrieved": "success"});
          process.exit();
          
        });
});





const getPost = async(userid) => {
    var query = "SELECT * FROM user_post WHERE user_post.post_id = ? VALUE";
    return new Promise(function(resolve, reject) {
        connection.query(query,[userid],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                throw err;
            }
            if (result.length == 0) {
                console.log("Post does not exist");
            } else {
                console.log("Post retrieved");
                return result;
                
            }

            
        });
    });
}