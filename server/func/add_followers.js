const db = require('./db_connection.js');
var name = "";
process.on("message", message => {
    db.conn.getConnection(function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          var data = {
            profile_id: message.profile_id,
            follower_id: message.follower_id
          }
//  addFollower(message.profile_id,message.follower_id, connection).then((answer) => {
         addFollower(data, connection).then((answer) => {
            connection.release();
            if (answer == "Relationship already exists") {
                process.send({"Error": "User-User relationship already exists"});
            } else {
                process.send(name);
                }
            process.exit();
          }).catch(function(result) {
            process.send(result);
            connection.release();
            process.exit();


          }); ;
        });
        
});
 //function addFollower(profile_id, follower_id, connection) {
 function addFollower(data, connection) {
    var profile_id = data.profile_id;
    var follower_id = data.follower_id;
    var selectQuery = "SELECT * FROM user_follower WHERE profile_id = '"+profile_id+"' AND follower_id = '"+follower_id+"'";
    var addFollowerQuery = "INSERT INTO user_follower (row_id, profile_id, follower_id) VALUES ?";
    var getName = "select name from profile where profile_id = "+profile_id;
    var row_id = Math.floor(Math.random() * 100000);
    var values1 = [[profile_id, follower_id]];
    var values2 = [[row_id, profile_id, follower_id]]
    return new Promise(function(resolve, reject) {
      connection.query(selectQuery,[values1],  function (err, result) {
        if (err) {
          console.log(err);
          resolve(result);
        }
        try {
          if (result.length == 1) {
            resolve("Relationship already exists");
            } else {
              connection.query(getName, async function(err, nameResult) {

                if(err){
                  reject(err);
                }
                nameResult = JSON.stringify(nameResult);
                nameResult = JSON.parse(nameResult);
                
                name = nameResult[0]['name'];

                connection.query(addFollowerQuery, [values2], function (err, result) {
              
                  if (err) {
                    reject(err.message);
                  /*
                  if (err.code === 'ER_DUP_ENTRY') {
                      addFollower(data, connection)
                  } else {
                  console.log(err);
                  reject(err.message);
                }
                */
                } 
  
                  resolve("Added");
                });
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

  