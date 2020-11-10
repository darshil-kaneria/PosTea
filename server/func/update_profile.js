const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    updateProfile(message.original_username, message.update_privateAcc, message.update_name, message.update_biodata, message.update_profilePic, connection).then(function(answer) {
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

 async function updateProfile(username, privacy,name, biodata, profilePic, connection) {
    var originalUsername = username;
    var selectQuery = "SELECT * FROM profile WHERE username = ?";
    var updateQuery = "UPDATE profile SET ";
    //is_private = '"+updated+"' WHERE username = '"+username+"'";
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[originalUsername],  async function (err, result) {
        if (err) {
          console.log(err);
          reject(err);}
        try {
          if (result.length == 0) {
            resolve("Account does not exist");
          } else {
            // if (result[0].username == user) {
            //     updateQuery = updateQuery+"username= '"+user+"'";
            // }
            // if (result[0].is_private == privacy) {
            //     updateQuery = updateQuery+"is_private= '"+privacy+"'";
            // }
            // if (result[0].name == name) {
            //     updateQuery = updateQuery+"name= '"+name+"'";
            // }
            // if (result[0].bio_data == biodata) {
            //     updateQuery = updateQuery+"bio_data= '"+biodata+"'";
            // }
            // await connection.query(updateAcc, (err, acc) => {
            //   if (err) {
            //     console.log(err);
            //     throw err;
            //   }
            //   return result;
            // })

            // updateQuery = updateQuery + "username = '" + newUsername + "', ";
            updateQuery = updateQuery + "is_private = '" + privacy + "', ";
            updateQuery = updateQuery + "name = '" + name + "', ";
            updateQuery = updateQuery + "bio_data = '" + biodata + "', ";
            updateQuery = updateQuery + "profile_img = '" + profilePic + "'";

            updateQuery = updateQuery +  " WHERE username = '"+result[0].username+"'"
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