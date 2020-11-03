const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(async function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    await getComments(message.post_id, connection).then(function(answer) {
        connection.release();
        process.exit();
    
  });
});
});

 function getComments(post_id, connection) {
    var selectQuery = "SELECT comment FROM engagement WHERE post_id = " + post_id + " ORDER BY creation_date DESC";
    return new Promise(async function(resolve, reject) {
      await connection.query(selectQuery, function (err, result) {
        if (err) {
          console.log(err);
          reject(err.message);
        }
        result = JSON.stringify(result);
        result = JSON.parse(result);
        process.send({"message": result});
        resolve(result);
      });
    })
  };