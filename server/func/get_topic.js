
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getTopic(message.topic_id, connection).then((result) => {
            connection.release();
            process.send(result);
            process.exit();
          }).catch((reject) => {
            connection.release();
            process.send(reject);
            process.exit();
          });
          
        });
});

const getTopic = async(topic_id, connection) => {
    var query = "SELECT * FROM topic_info WHERE topic_info.topic_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[topic_id],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("Topic does not exist");
                reject("Topic does not exist");
            } else {
                console.log("Topic retrieved");
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
