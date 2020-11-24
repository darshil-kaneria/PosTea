
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getPosts(message.profile_id, connection).then((result) => {
            process.send(result);
            connection.release();
            process.exit();
          }).catch((reject) => {
            process.send(reject);
            connection.release();
            process.exit();
          });
          
        });
});

const getPosts = async(profile_id, connection) => {
    var query = "SELECT * FROM user_post WHERE user_post.profile_id = " + String(profile_id);
    return new Promise(function(resolve, reject) {
       connection.query(query, function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("No posts made by this user");
                reject("No posts made by this user");
            } else {
                console.log("Posts retrieved");
                //console.log(result);
                result = JSON.stringify(result);
                result = JSON.parse(result);
                console.log(result);
                resolve(result);

                // return result;  
            }
        });
    });
}
