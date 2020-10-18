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


    
}