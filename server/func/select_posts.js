const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getPosts(message.topicID, connection);
          connection.release();
          process.send({"posts retrieved": "success"});
          process.exit();
          
        });
});

function getPosts(topic_id, connection) {
    console.log(topic_id);
    console.log("print");
    var selectquery = "SELECT * FROM user_post WHERE topic_id = ?";
    return new Promise(function (resolve, reject) {
        connection.query(selectquery, [topic_id], function(err, result) {
            if (err) {
                console.log(err);
                reject(result);
            } else {
                if (result.length == 0) {
                    resolve("Posts for topic does not exist");
                } else {
                    console.log(result);
                    resolve(result);
                }
            }
        })
    });



}