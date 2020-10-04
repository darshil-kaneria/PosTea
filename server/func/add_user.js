const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          addUser(message.username, connection).then(function(answer){
           // console.log(answer.length);
            connection.release();
            if (answer == "Account already exists") {
              process.send({"Error": "User already exists"});
            } else {
            process.send({"userAdded": message.username});
            }
            process.exit();
          }) 
        });
        
});

 function addUser(user, connection) {
    var username = user;
    var selectQuery = "SELECT * FROM account WHERE username = ?";
    var addProfileQuery = "INSERT INTO account (username, acc_creat_date) VALUES ?";
    var curr_date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var values = [[username, curr_date]];
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[user],  function (err, result) {
        if (err) {
          console.log(err);
          throw err;}
        try {
          if (result.length == 1) {
            resolve("Account already exists");
          } else {
            connection.query(addProfileQuery, [values], function (err, result) {
              if (err) {
                throw err;
              } 
                resolve("Added")
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

  