const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          
          console.log('Database connection established');
          await addEngagement(message.str, connection);
          //connection.release();
          //process.send({"userAdded": message.username});
          //p//rocess.exit(); // It is very important to exit, or else heroku server will start accumulating orphaned processes.
          
        });
});

const addEngagement = async function(top_name,  connection) {
    var topic_id = top_id;
    var addtopicinfoq = "INSERT INTO engagement (engagement_id, post_id, profile_id, like_or_dislike, comment) VALUES ?";
    //var date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var vals = [["02", "01", "03", "1", "This is an interesting topic"]];


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