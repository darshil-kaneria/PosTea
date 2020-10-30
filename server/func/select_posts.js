const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          
          //process.send({"posts retrieved": "success"});
          await getPosts(message.topic_id, connection).then((value)=> {
                process.send(value, );
                connection.release();
            //process.send(resul);
                process.exit();
        
          }).catch((result) => {
              process.send(result);
              connection.release();
              process.exit();


          });
          
          
        });
});

function getPosts(topic_id, connection) {
    console.log(topic_id);
    console.log("print");
    var selectquery = "SELECT * FROM user_post WHERE topic_id = " +topic_id + " ORDER BY creation_date DESC LIMIT 10";
    console.log(selectquery);
    return new Promise(function (resolve, reject) {
        connection.query(selectquery, function(err, result) {
            if (err) {
                //console.log(err);

                reject(err.message);
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