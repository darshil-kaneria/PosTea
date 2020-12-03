const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    updateProfileMode(message.profileID, message.isPrivate, connection).then(function(answer) {
      process.send(answer);
      connection.release();
      process.exit();
    
  }).catch(function(error) {
    process.send(error);
    connection.release();
    process.exit();
  });
});
});

 async function updateProfileMode(profileID, isPrivate, connection) {
    var updateQuery = "UPDATE profile SET is_private = '"+ isPrivate.toString() +"' WHERE profile_id = '"+ profileID.toString() +"'";
    return new Promise(function(resolve, reject) {
      connection.query(updateQuery,  async function (err, result) {
        if (err) {
          console.log(err.message);
          reject(err.message);
        }
        resolve(result);
      });
    })
  };