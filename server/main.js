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
// var data = {
//   username: req.query.account
// };
handlePosts.send(req.body);
handlePosts.on("message", message => res.send(message));

});

app.post('/addtopicinfo', (req, res) => {
  const handtopic = fork('./func/add_topic.js');
  // var data = {
  //   topic_name: req.query.topic_name,
  //   top_description: req.query.topic_description,
  // }
  handtopic.send(req.body);
  handtopic.on("miessage", message => res.send(message));
});

app.post('/addprofile', (req, res) => {

  const handleAddProfile = fork('./func/add_profile.js');
  // var data = {
  //   username: req.query.account,
  //   is_private: req.query.is_private, 
  //   name: req.query.name, 
  //   bio_data: req.query.bio_data
  // };
  handleAddProfile.send(req.body);
  handleAddProfile.on("message", message => res.send(message));
  
  });
   
app.get('/getprofile', (req, res)=> {
  const handleGetProfile = fork('./func/get_profile.js');
  var data = {
    username: req.query.account
  };
  handleGetProfile.send(data);
  handleGetProfile.on("message", message => res.send(message));
});

app.post('/updateusername', (req,res)=> {
  const handleUpdate = fork('./func/update_username.js');
  var data = {
    username: req.query.account,
    updated: req.query.update
  };
  handleUpdate.send(data);
  handleUpdate.on("message", message => res.send(message));
});

app.post('/updateprivacy', (req,res)=> {
  const handleUpdate = fork('./func/update_privacy.js');
  var data = {
    username: req.query.account,
    updated: req.query.update
  };
  handleUpdate.send(data);
  handleUpdate.on("message", message => res.send(message));
});

app.post('/updatename', (req,res)=> {
  const handleUpdate = fork('./func/update_name.js');
  var data = {
    username: req.query.account,
    updated: req.query.update
  };
  handleUpdate.send(data);
  handleUpdate.on("message", message => res.send(message));
});

app.post('/updatebiodata', (req,res)=> {
  const handleUpdate = fork('./func/update_biodata.js');
  var data = {
    username: req.query.account,
    updated: req.query.update
  };
  handleUpdate.send(data);
  handleUpdate.on("message", message => res.send(message));
});

app.post('/deletepost', (req, res) => {
  const handledelete = fork('./func/delete_post.js');
  // var data = {
  //   postId: req.query.postId,
  //   profileId: req.query.profileId

  // }
  handledelete.send(req.body);
  handledelete.on("message",message => res.send(message));

});

app.post('/makePost', (req, res) => {
  const handleUserPosts = fork('./func/add_post.js');
  handleUserPosts.send(req.body);
  res.send(req.body);
});

app.get('/getpost', (req, res) => {
  const getpost = fork('./func/get_post.js');
  var data = {
    post_id: req.query.post_id
  };
  getpost.send(data);
  getpost.on("message", message => res.send(message));
  
  
});

app.get('/getcomments', (req, res) => {
  const handleComments = fork("./func/get_comments.js");
  var data = {
    post_id: req.query.post_id
  }
  handleComments.send(data);
  handleComments.on("message", message => res.send(message));
});

// app.post('updateLikesDislikes', (req, res) => {
//   const handleLikesDislikes = fork("./func/update_likes_dislikes.js");
//   handleLikesDislikes.send(req.body);
//   handleLikesDislikes.on("message", message => res.send(message));
// });

app.post('/addEngagement', (req, res) => {
  const handleEngagements = fork('./func/add_engagement.js');
  handleEngagements.send(req.body);
  handleEngagements.on("message", message => res.send(message));
});

app.get("/refreshTimeline", (req, res) => {
  const handleRefreshTimeline = fork('./func/refreshTimeline.js');
  data = {
    profileID: req.query.profile_id,
    offset: req.query.post_offset
  }
  handleRefreshTimeline.send(data);
  handleRefreshTimeline.on("message", message => res.send(message));
  
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



