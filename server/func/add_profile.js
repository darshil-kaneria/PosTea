const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    addProfile(message.username, message.privateAcc, message.name, message.biodata, message.profilePic, connection).then(function(answer) {
      connection.release();
      if (answer == "Account already exists") {
        process.send({"Error": "User information already exists"});
      } else {
        process.send(answer);
      }
      process.exit();
  });
});
});

 function addProfile(user, is_private, name, bio_data, profilePic, connection) {
    var username = user;
    var profile_id = -1;
    profile_id = Math.floor(Math.random() * 100000);
    var selectQuery = "SELECT * FROM profile WHERE username = ?";
    var addProfileQuery = "INSERT INTO profile (profile_id, username, is_private, name, bio_data, profile_img) VALUES ?";
    var values = [[profile_id, username, is_private, name, bio_data, profilePic]];
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[user],  function (err, result) {
        if (err) {
          console.log(err);
          reject(err.message);
        }
        try {
          if (result.length == 1) {
            resolve("Account already exists");
          } else {
            connection.query(addProfileQuery, [values], function (err, result) {
              if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    addProfile(user, is_private, name, bio_data, connection);
                } else {
                console.log(err);
                reject(err.message);
              }
              } 
                resolve(profile_id);
              });
          }
        }
        catch (error){
          reject(err.message);
        }
        return;
      });
    })
  };