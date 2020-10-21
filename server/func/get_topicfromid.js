
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await convert_id_to_topic(message.topic_id, connection);
          connection.release();
          process.send({"Topic name retrieved": "success"});
          process.exit();
          
        });
});

const convert_id_to_topic = async(topic_id, connection) => {
    var query = "SELECT * FROM topic_info WHERE topic_info.topic_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[topic_id],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                throw err;
            }
            if (result.length == 0) {
                console.log("Topic does not exist");
            } else {
                console.log("Topic name retrieved");
                console.log(result[0].topic_name);
                resolve(result[0].topic_name);
                // return result;  
            }
        });
    });
}