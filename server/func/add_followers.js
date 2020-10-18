const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          var data = {
            profile_id: req.query.profile_id,
            follower_id: req.query.follower_id
          }
          //  addFollower(message.profile_id,message.follower_id, connection).then((answer) => {
         addFollower(data, connection).then((answer) => {
            connection.release();
            if (answer == "Relationship already exists") {
                process.send({"Error": "User-User relationship alreadt exists"});
            } else {
                process.send({"Success": "Follower relationship created"});
                }
            process.exit();
          });
        });
        
});
 //function addFollower(profile_id, follower_id, connection) {
 function addFollower(data, connection) {
    var profile_id = data.profile_id;
    var follower_id = data.follower_id;
    var selectQuery = "SELECT * FROM user_follower WHERE profile_id = '"+profile_id+"' AND follower_id = '"+follower_id+"'";
    var addFollowerQuery = "INSERT INTO user_follower (row_id, profile_id, follower_id) VALUES ?";
    var row_id = Math.floor(Math.random() * 100000);
    var values1 = [[profile_id, follower_id]];
    var values2 = [[row_id, profile_id, follower_id]]
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[values1],  function (err, result) {
        if (err) {
          console.log(err);
          throw err;}
        try {
          if (result.length == 1) {
            resolve("Relationship already exists");
            } else {
                connection.query(addFollowerQuery, [values2], function (err, result) {
              if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    addFollower(data, connection)
                } else {
                console.log(err);
                throw err;
                }
              } 
                resolve("Added");
              });
          }
        }
        catch (error){
          throw err;
        }
        return;
      });
    })
  };

  