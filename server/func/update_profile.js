const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    updateProfile(message.username, message.privacy, message.name, message.biodata, connection).then(function(answer) {
      connection.release();
      if (answer == "Account does not exist") {
        process.send({"Error": "No account with that username exists"});
      } else {
        process.send({"User profile information updated": "Successfully"});
      }
      process.exit();
    
  });
});
});

 function updateName(user, privacy,name, biodata, connection) {
    var username = user;
    var selectQuery = "SELECT * FROM profile WHERE username = ?";
    console.log(updated);
    var updateQuery = "UPDATE profile SET ";
    //is_private = '"+updated+"' WHERE username = '"+username+"'";
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[user],  function (err, result) {
        if (err) {
          console.log(err);
          throw err;}
        try {
          if (result.length == 0) {
            resolve("Account does not exist");
          } else {
            if (result[0].username == user) {
                updateQuery = updateQuery+"username= '"+user+"'";
            }
            if (result[0].is_private == privacy) {
                updateQuery = updateQuery+"is_private= '"+privacy+"'";
            }
            if (result[0].name == name) {
                updateQuery = updateQuery+"name= '"+name+"'";
            }
            if (result[0].bio_data == biodata) {
                updateQuery = updateQuery+"bio_data= '"+biodata+"'";
            }
            updateQuery = updateQuery +  " WHERE username = '"+result[0].username+"'"
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
          throw err;
        }
        return;
      });
    })
  };