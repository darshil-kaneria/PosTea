const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    updateName(message.username, message.updated, connection).then(function(answer) {
      connection.release();
      if (answer == "Account does not exist") {
        process.send({"Error": "No account with that username exists"});
      } else {
        process.send({"User biodata updated": "Successfully"});
      }
      process.exit();
    
  });
});
});

 function updateName(user, updated, connection) {
    var username = user;
    var selectQuery = "SELECT * FROM profile WHERE username = ?";
    var updateQuery = "UPDATE profile SET bio_data = '"+updated+"' WHERE username = '"+username+"'";
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[user],  function (err, result) {
        if (err) {
          console.log(err);
          reject("An error occurred");
          reject(err.message);
        }
        try {
          if (result.length == 0) {
            resolve("Account does not exist");
          } else {
            connection.query(updateQuery, function (err, result) {
              if (err) {
                console.log(err);
                reject(err.message);
              } 
                resolve("Added");
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