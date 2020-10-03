const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          
          console.log('Database connection established');
          await addTopicInfo(message.topic_name, message.top_description, connection);
          connection.release();
          //process.send({"userAdded": message.username});
          //p//rocess.exit(); // It is very important to exit, or else heroku server will start accumulating orphaned processes.
          
        });
});

const addTopicInfo = async function(top_name, topic_description, connection) {
    //var topic_id = top_id;
    var top_id = Math.random()
    var addtopicinfoq = "INSERT INTO topic_info (topic_id, topic_creator_id, topic_name, topic_description, topic_img, creation_date) VALUES ?";
    var date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var vals = [[02, 01, top_name, topic_description, "", date]];
    await connection.query(addtopicinfoq,[vals], function(err, result) {
        if (err) {
            console.log(err);
            throw err;
        } else {
          console.log("topic info added sucessfully")
          return result;  
        }

    });


}

