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

// conn.getConnection(function(err, connection) {
//     if (err) {
//       return console.error('error: ' + err.message);
//     }
  
//     console.log('Database connection established');
//     connection.release();
//   });

  
//Create a fork object - test concurrency only
const fork = require("child_process").fork;
app.get('/', (req, res)=>{
    
    console.log("request received on home");
    const child = fork('./test_concurrency_one.js');
    child.send({"number": parseInt(req.query.number)});
    child.on("message", message => res.send(message));

});

// Handle requests to make a post on PosTea
app.get('/post', (req, res) => {

const handlePosts = fork('./add_profile.js');
var data = {
  username: req.query.account
};
handlePosts.send(data);
handlePosts.on("message", message => res.send(message));

});




































app.listen(PORT, ()=>console.log("listening on port "+PORT));

// app.get('/profile', (req,res)=> {
//   addUsername(req.username, req.is_private, req.name, req.biodata)
// });

// function addUserInfo(username, is_private, name, biodata) {
// var sql = "INSERT INTO profile (username, is_private, name, bio_data) VALUES ?";
//   var values = [
//     [username, is_private, name, biodata]
//     ];
//   con.query(sql, [values], function (err, result) {
//     if (err) throw err;
//   });
// }
// app.get('/username', (req,res)=>{
//   addUsername(req.username)
// });

// function addUsername(username) {
//   var currdate = new Date();
//   var sql = "INSERT INTO account (username, acc_creat_date) VALUES ("+username+","+currdate+")";
//   conn.query(sql, function (err, result) {
//     if (err) throw err;
//     console.log("1 record inserted");
// });}
