const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function (err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    getProfile(message.username, connection).then(function (answer) {
      
      if (answer == "Account does not exist") {
        process.send({ "Error": "User does not exist" });
      } else {
        var privacy = "Yes";
        if (answer[0].is_private == 0) {
          privacy = "No"
        }
        var profile_information = '{Profile ID: ' + answer[0].profile_id + ', Username: ' + answer[0].username + ', Private Account: ' + privacy + ', Name: ' + answer[0].name + ', Biodata: ' + answer[0].bio_data + '}';
        // profile_information = JSON.parse(JSON.stringify(profile_information));
        var profileInfoJson = {
          profile_id: answer[0].profile_id,
          username: answer[0].username,
          privacy: privacy,
          name: answer[0].name,
          biodata: answer[0].bio_data
        }
        //console.log(profileInfoJson);

        process.send({ "message": profileInfoJson });
      }
      connection.release();
      process.exit();

    }).catch(function(result) {
      process.send(result);
      connection.release();
      process.exit();



    });
  });
});

function getProfile(user, connection) {
  var username = user;
  var selectQuery = "SELECT * FROM profile WHERE username = ?";
  return new Promise(function (resolve, reject) {
    connection.query(selectQuery, [user], function (err, result) {
      if (err) {
        console.log(err);
        reject(err.message);
      }
      
     if (result.length == 0) {
        resolve("Account does not exist");
      } else {
        //console.log(result);
        resolve(result);
      }
      
    });
  })
};