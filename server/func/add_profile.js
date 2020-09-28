const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          
          console.log('Database connection established');
          await addUser(message.username, connection);
          connection.release();
          process.send({"userAdded": message.username});
          process.exit(); // It is very important to exit, or else heroku server will start accumulating orphaned processes.
          
        });
});



const addUser = async function(user, connection) {


    var username = user;
    var addProfileQuery = "INSERT INTO account (username, acc_creat_date) VALUES ?";
    var curr_date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var values = [[username, curr_date]];
    await connection.query(addProfileQuery, [values], function (err, result) {
          if (err) {
            console.log(err);
            throw err;}
          console.log();
          return result;
        });
      
  };

  