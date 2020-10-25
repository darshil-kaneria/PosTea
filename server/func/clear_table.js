const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          
          console.log('Database connection established');
          await clearTable(message.table, connection);
          connection.release();
          process.send({"table_deleted": "success"});
          process.exit();
          
        });
});

const clearTable = async function(tableName, connection){

    var clearTableQuery = "DELETE FROM "+tableName;

    var resp = await connection.query(clearTableQuery, function (err, result) {
        if (err) {
          console.log(err);
          throw err;
        }
        return "success";
      });

      return resp;

};