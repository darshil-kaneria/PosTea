const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    addSettings(message.privacy, message.dark_theme, message.accessibility, message.profile_id, connection).then(function(answer) {
      connection.release();
      if (answer == "Account already exists") {
        process.send({"Error": "User information already exists"});
      } else {
        process.send(answer);
      }
      process.exit();
  }).catch(function(result) {
    process.send(result);
    process.exit();


  });
});
});

 function addSettings(privacy, dark_theme, accessibility, profile_id, connection) {
    var pid = profile_id;
    var settings_id = -1;
    settings_id = Math.floor(Math.random() * 100000);
    var selectQuery = "SELECT * FROM user_settings WHERE profile_id = ?";
    var addSettingsQuery = "INSERT INTO user_settings (privacy, dark_theme, accessibility, profile_id, settings_id) VALUES ?";
    var values = [[privacy, dark_theme, accessibility, pid, settings_id]];
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[user],  function (err, result) {
        if (err) {
          reject(err.message);
        }
        try {
          if (result.length == 1) {
            resolve("Account already exists");
          } else {
            connection.query(addSettingsQuery, [values], function (err, result) {
                resolve({"settings_id": settings_id});
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