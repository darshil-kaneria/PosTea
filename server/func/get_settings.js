const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function (err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    var getVar = message.profile_id;
    console.log('Database connection established');
    getSettings(getVar, connection).then(function (answer) {
      if (answer == "Account does not exist") {
        process.send({ "Error": "User does not exist" });
      } else {
        var privacy = "Yes";
        if (answer[0].privacy == 0) {
          privacy = "No"
        } 
        var settingsInfoJson = {
          privacy: privacy,
          dark_theme: answer[0].dark_theme,
          accessibility: answer[0].accessibility,
          profile_id: answer[0].profile_id,
          settings_id: answer[0].settings_id
        }
        process.send({ "message": settingsInfoJson });
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

function getSettings(user, connection) {
  var selectQuery = "SELECT * FROM user_settings WHERE profile_id = ?";
  return new Promise(function (resolve, reject) {
    connection.query(selectQuery, [user], function (err, result) {
      if (err) {
        console.log(err);
        reject(err.message);
      }
      
     if (result.length == 0) {
        resolve("Account does not exist");
      } else {
        resolve(result);
      }
      
    });
  })
};