const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          add_commeng(message.postID, message.like, message.engag_id, connection);
           // console.log(answer.length);
            c
        });
        
});

const addPost = async (postID, likes, engagement_id, connection) => {
    var id = Math.floor(Math.random() * 100000);
    var addquery = "INSERT INTO comm_engagement (comm_id, post_id, comm_like, engagement_id) VALUES ?";
    





}