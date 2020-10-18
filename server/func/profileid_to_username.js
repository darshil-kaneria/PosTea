
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await convert_id_to_username(message.profile_id, connection);
          connection.release();
          process.send({"Username retrieved": "success"});
          process.exit();
          
        });
});

const convert_id_to_username = async(profileId, connection) => {
    var query = "SELECT * FROM profile WHERE profile.profile_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[profileId],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                throw err;
            }
            if (result.length == 0) {
                console.log("Profile does not exist");
            } else {
                console.log("Username retrieved");
                console.log(result[0].username);
                resolve(result[0].username);
                // return result;  
            }
        });
    });
}