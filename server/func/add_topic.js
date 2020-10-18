const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          
          console.log('Database connection established');
          var data = {
            topicText: message.topicText,
            topicID: message.topicID,
            topic_creator_id: message.topicCreatorID,
            topic_description: message.topicDescription
          }
          await addTopicInfo(data, connection);
          connection.release();
          //process.send({"userAdded": message.username});
          //p//rocess.exit(); // It is very important to exit, or else heroku server will start accumulating orphaned processes.
          
        });
});

const addTopicInfo = async function(data, connection) {
    //var topic_id = top_id;
    console.log("data");
    var top_id = Math.random()
    var addtopicinfoq = "INSERT INTO topic_info (topic_id, topic_creator_id, topic_name, topic_description, topic_img, creation_date) VALUES ?";
    var date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var vals = [[data.topicID, data.topic_creator_id, data.topicText, data.topic_description, "", date]];
    return new Promise(function(resolve, reject) {
      connection.query(addtopicinfoq,[vals], function(err, result) {
        if (err) {
            console.log(err);

            reject(result);
            //throw err;
        } else {
          //console.log("topic info added sucessfully");
          resolve(result);
          //return result;  
        }

      });
    })


}

