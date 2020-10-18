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
        process.send({"User name updated": "Successfully"});
      }
      process.exit();
    
  });
});
});

 function updateName(user, updated, connection) {
    var username = user;
    var selectQuery = "SELECT * FROM profile WHERE username = ?";
    console.log(updated);
    var updateQuery = "UPDATE profile SET name = '"+updated+"' WHERE username = '"+username+"'";
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[user],  function (err, result) {
        if (err) {
          console.log(err);
          reject("An error occured");
          throw err;}
        try {
          if (result.length == 0) {
            resolve("Account does not exist");
          } else {
            connection.query(updateQuery, function (err, result) {
              if (err) {
                console.log(err);
                throw err;
              } 
                resolve("Added");
              });
          }
        }
        catch (error){
          reject("an error occured");
          throw err;
        }
        return;
      });
    })
  };