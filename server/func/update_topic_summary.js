const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    updateTopic(message.originalTopicID, message.creator_id, message. user_id, message.update_topic_desc, connection).then(function(answer) {
      connection.release();
      if (answer == "Topic does not exist") {
        process.send({"Error": "No topic with that name exists"});
      } else {
        process.send({"Topic information updated": "Successfully"});
      }
      process.exit();
    
  });
});
});

 async function updateTopic(topic_id, creator_id, user_id, new_topic_desc, connection) {
    var selectQuery = "SELECT * FROM topic_info WHERE topic_id = ?";
    var updateQuery = "UPDATE topic_info SET topic_description = '"+new_topic_desc+"' WHERE topic_id = '"+topic_id+"'";
    return new Promise(function(resolve, reject) {
      if (creator_id != user_id) {
          resolve("This user cannot edit this topic");
      }
      connection.query(selectQuery,[topic_id],  async function (err, result) {
        if (err) {
          console.log(err);
          reject(err);}
        try {
          if (result.length == 0) {
            resolve("Topic does not exist");
          } else {
            await connection.query(updateQuery, function (err, result) {
              if (err) {
                console.log(err);
                reject (err);
              } 
                resolve("Updated");
              });
          }
        }
        catch (error){
          reject (err);
        }
        return;
      });
    })
  };