
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          getEngagement(message.post_id, connection).then((value)=> {
                process.send(value);
                connection.release();
                process.exit();
          }) .catch(function(result) {
            process.send(result);
            connection.release();
            process.exit();
          });
        });
});

const getEngagement = async(postId, connection) => {
    var query = "SELECT * FROM engagement WHERE post_id = ?";
    console.log(postId);
    return new Promise(function(resolve, reject) {
       connection.query(query,[postId],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            //console.log(result)
            if (result.length == 0) {
                reject("Post does not exist");
            } else {
                console.log("Post retrieved");
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
