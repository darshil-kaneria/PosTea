/**
 * Create a child process which executes test_concurrency_one.js
 * The child process is created when a client hits the '/' endpoint.
 * To test this functionality, go to postea-server.herokuapp.com/?number=<enter_number>
 * To test different execution times, try numbers like 100000000, 1000000, 100 in place of <enter_number>
 * Do not exceed more than 255 processes since that is how many processes heroku supplies with the free dyno that we are currently running.
 */

const express = require('express');
const app = express();
const PORT = process.env.PORT || 23556;
const password = process.env.DB_ACCESS;
const mysql = require('mysql');

var conn = mysql.createPool({
    host: "postea-business.mysql.database.azure.com", 
    user: "posteabusiness@postea-business", 
    password: password, 
    database: 'postea-db', 
    port: 3306, 
});

conn.getConnection(function(err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
  
    console.log('Database connection established');
    connection.release();
  });

//Create a fork object
const fork = require("child_process").fork;
app.get('/', (req, res)=>{
    
    console.log("request received on home");
    const child = fork('./test_concurrency_one.js');
    child.send({"number": parseInt(req.query.number)});
    child.on("message", message => res.send(message));

});

app.listen(PORT, ()=>console.log("listening on port "+PORT));