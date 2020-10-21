
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getTopic(message.topic_id, connection);
          connection.release();
          process.send({"Topic retrieved": "success"});
          process.exit();
          
        });
});

const getTopic = async(topic_id, connection) => {
    var query = "SELECT * FROM topic_info WHERE topic_info.topic_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[topic_id],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err);
            }
            if (result.length == 0) {
                console.log("Topic does not exist");
            } else {
                console.log("Topic retrieved");
                console.log(result);
                resolve(result);
                // return result;  
            }
        });
    });
}
