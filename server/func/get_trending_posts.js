const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(function (err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');

  });
});

function getPosts(connection) {
    var selectposts 

}