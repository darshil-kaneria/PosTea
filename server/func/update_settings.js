const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    updateSettings(message.update_privacy, message.update_dark_theme, message.update_accessibility, message.profile_id,  connection).then(function(answer) {
      connection.release();
      if (answer == "Account does not exist") {
        process.send({"Error": "No account with that profile id exists"});
      } else {
        process.send({"User settings information updated": "Successfully"});
      }
      process.exit();
    
  });
});
});

 async function updateSettings(privacy, dark_theme, accessibility, profile_id, connection) {
    var original_pid = profile_id;
    var selectQuery = "SELECT * FROM user_settings WHERE username = ?";
    var updateQuery = "UPDATE user_settings SET ";
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[original_pid],  async function (err, result) {
        if (err) {
          console.log(err);
          reject(err);}
        try {
          if (result.length == 0) {
            resolve("Account does not exist");
          } else {
            updateQuery = updateQuery + "privacy = '" + privacy + "', ";
            updateQuery = updateQuery + "dark_theme = '" + dark_theme + "', ";
            updateQuery = updateQuery + "accessibility = '" + accessibility + "'";
            updateQuery = updateQuery +  " WHERE profile_id = '"+result[0].profile_id+"'"
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