/**
 * This file is divided into two parts; User endpoints and Dev endpoints. The former are supposed to be used to communicate with the user and
 * the database while the latter are supposed to be used as dev tools only.
 * To allow for a larger request processing capacity, each function must be added in a seperate file and should be forked into a new child when needed.
 * Do not exceed more than 255 processes since that is how many processes heroku supplies with the free dyno that we are currently running.
 */

const express = require('express');
const app = express();
app.use(express.static("dir"));
app.use(express.json({limit: '2mb'}));
const PORT = process.env.PORT || 23556;

//Create a fork object - test concurrency only
const fork = require("child_process").fork;
app.get('/', (req, res)=>{
    
    console.log("request received on home");
    const child = fork('./test_concurrency_one.js');
    child.send({"number": parseInt(req.query.number)});
    child.on("message", message => res.send(message));

});

/**
 * User endpoints
 */

// Handle requests to make a post on PosTea
app.post('/adduser', (req, res) => {

const handlePosts = fork('./func/add_user.js');
var data = {
  username: req.query.account
};
handlePosts.send(data);
handlePosts.on("message", message => res.send(message));

});

app.get('/addtopicinfo', (req, res) => {
  const handtopic = fork('./func/add_topic.js');
  var data = {
    topic_name: req.query.topic_name,
    top_description: req.query.topic_description,
  }
  handtopic.send(data);
  handtopic.on("message");

});

app.post('/addprofile', (req, res) => {

  const handlePosts = fork('./func/add_profile.js');
  var data = {
    username: req.query.account,
    is_private: req.query.is_private, 
    name: req.query.name, 
    bio_data: req.query.bio_data
  };
  handlePosts.send(data);
  handlePosts.on("message", message => res.send(message));
  
  });
   
app.post('/makePost', (req, res) => {
  const handleUserPosts = fork('./func/add_post.js');
  handleUserPosts.send(req.body);
  res.send(req.body);
});

app.listen(PORT, ()=>console.log("listening on port "+PORT));

/**
 * Dev endpoints - use with caution.
 */

 // Clears all data for a specific table
app.get('/cleartable', (req, res) => {

  const clearTableChild = fork('./func/clear_table.js');
  var data = {
    table: req.query.table
  };
  clearTableChild.send(data);
  clearTableChild.on("message", message => res.send(message));
});


/*
app.get('/getpost', (req, res) => {
  const getpost = fork('./func/get_post.js')
  var data = {
    table: req.query.table


  };
  
  
});

*/
