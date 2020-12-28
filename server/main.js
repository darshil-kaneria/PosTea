/**
 * This file is divided into two parts; User endpoints and Dev endpoints. The former are supposed to be used to communicate with the user and
 * the database while the latter are supposed to be used as dev tools only.
 * To allow for a larger request processing capacity, each function must be added in a seperate file and should be forked into a new child when needed.
 * Do not exceed more than 255 processes since that is how many processes heroku supplies with the free dyno that we are currently running.
 */
const cluster = require('cluster');
const express = require('express');
const Clients = require("./clients")
const app = express();
app.use(express.static("dir"));
app.use(express.json({limit: '2mb'}));
const PORT = process.env.PORT || 23556;
const numCPUs = require('os').cpus().length;
var cors = require('cors');
const ws = require('ws');
const db = require('./func/db_connection.js');
const { send, kill } = require('process');
var redis = db.redis_conn;
const bearerToken = require('express-bearer-token');

var lastWorkerPID = -1;

app.use(bearerToken());
app.use(function (req, res, next) {
  try {
    const TOKEN = process.env.TOKEN;
      let error;

      // Check if the received request has an authorization header
      if (req.headers) {
        if (req.headers.authorization) {
          const splits = req.headers.authorization.split(' ');
          if (splits.length === 2 && splits[0] === 'Bearer') {
            if (splits[1] === TOKEN) {
              error = false;
            } else {
              error = true;
            }
          } else {
            error = true;
          }
        } else {
          error = true;
        }
      } else {
        error = true;
      }
      // If there is no auth header
      if (error) {
        res.status(401).send('Unauthorized!');
      } else {
        next();
      } 
  } catch (e) {
    console.error(e);
  }
});

if (cluster.isMaster) {
  console.log(`Master ${process.pid} is running`);
  
  // Fork workers.
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker, code, signal) => {
    console.log(`worker ${worker.process.pid} died`);
  });
}
else {
  const clients = new Clients();
  const server = app.listen(PORT, ()=>console.log("listening on port "+PORT+", PID: "+process.pid));
  var publisher = redis.createClient(process.env.REDISCLOUD_URL, {no_ready_check: true});
  var kill_process = false;

  app.use(cors({
    origin: ["http://postea-server.herokuapp.com"],
    credentials: true
  }));

  const fork = require("child_process").fork;

  // Setup websocket for notifications and activity tab

  const wsServer = new ws.Server({ noServer: true });
  wsServer.on('connection', (ws) => {
    console.log("Websocket initiated by: "+ws._socket.remoteAddress + " on PID: "+process.pid);
    var main_tm = setInterval(ping, 30000);
    var subscriber = redis.createClient(process.env.REDISCLOUD_URL, {no_ready_check: true});
    var tm;
    function ping() {
      ws.send('__ping__');
      tm = setTimeout(function () {  
        console.log("Closing connection for "+ws._socket.remoteAddress);
        clearTimeout(tm);
        clearInterval(main_tm);
        kill_process = true;
        subscriber.quit();
        ws.close();
        
      }, 10000);
    }
    function pong() {
      clearTimeout(tm);
    }
    ws.on('message', (profile_id) => {
      // if(profile_id == "__pong__"){
      //   pong();
      //   console.log("pong sent");
      //   return
      // }
      pong();
      if(clients.clientList[profile_id] == undefined){
        clients.saveClient(profile_id, ws);
        clients.clientList[profile_id].send("HELLO CLIENT");
        subscriber.subscribe(String(profile_id));
        console.log("Subscribed to: " + String(profile_id));
      }
    });
    

    subscriber.on("message", (channel, message) => {
      var receivedMessage = JSON.parse(message);
      var engagement = "";
      if(receivedMessage['like_dislike'] == 1){
        engagement = " liked your post.";
      }
      else if(receivedMessage['comment'] !== null){
        engagement = " commented on your post.";
      }
      else if(receivedMessage['followReq'] == true){
        engagement = " is following you.";
      }
      var sender = String(receivedMessage['senderClient']);
      var senderName = String(receivedMessage['senderName']);
      var sendJSON = {
        "senderName": senderName,
        "senderID": sender,
        "engagement": engagement,
        "postID": receivedMessage['postID']
      };
      var sendMessageJson = JSON.stringify(sendJSON);
      ws.send(sendMessageJson);
    });

  });
  
  server.on('upgrade', (request, socket, head) => {
    wsServer.handleUpgrade(request, socket, head, socket => {
      wsServer.emit('connection', socket, request);
    });
  });

/**
 * User endpoints
 */

/**
 * Route Methods 
 */

// Profile methods
app.route('/profile/:pID?')
  .get((req, res) => {
    const handleGetProfile = fork('./func/get_profile.js');
    if(req.params.pID){
      var data = {
        profile: req.params.pID,
        flag: 1
      };
    }
    else{
      var data = {
        username: req.query.username,
        flag: 0
        };
    }
    handleGetProfile.send(data);
    handleGetProfile.on("message", message => res.send(message));
  })
  .post((req, res) => {
    const handleAddProfile = fork('./func/add_profile.js');
    handleAddProfile.send(req.body);
    handleAddProfile.on("message", message => res.send(message));
  })
  .put((req, res) => {
    const handleUpdate = fork('./func/update_profile.js');
    handleUpdate.send(req.body);
    handleUpdate.on("message", message => res.send(message));
  });

// Settings methods
app.route('/settings/:pID')
.get((req, res) => {
  const handleGetSettings = fork('./func/get_settings.js');
  var data = {
    profile_id: req.params.pID
  };
  handleGetSettings.send(data);
  handleGetSettings.on("message", message => res.send(message));
})
.post((req, res) => {
  const handleAddSettings = fork('./func/add_settings.js');
  handleAddSettings.send(req.body);
  handleAddSettings.on("message", message => res.send(message));
})
.put((req, res) => {
  const handleUpdateSettings = fork('./func/update_settings.js');
  handleUpdateSettings.send(req.body);
  handleUpdateSettings.on("message", message => res.send(message));
});

// Post methods
app.route("/post")
  .get((req, res) => {
    const getpost = fork('./func/get_post.js');
    var data = {
      post_id: req.query.post_id
    };
    getpost.send(data);
    getpost.on("message", message => res.send(message));
  })
  .post((req, res) => {
    const handleUserPosts = fork('./func/add_post.js');
    handleUserPosts.send(req.body);
    res.send(req.body);
  })
  .delete((req, res) => {
    const handledelete = fork('./func/delete_post.js');
    handledelete.send(req.body);
    handledelete.on("message",message => res.send(message));
  });

// Engagement Methods
app.route("/engagement")
  .get((req,res) => {
    const handleEngagements = fork("./func/get_engagement_post.js");
    var data = {
      post_id: req.query.post_id
    }
  handleEngagements.send(data);
  handleEngagements.on("message", message => res.send(message));
  })
  .post((req, res) => {
    const handleEngagements = fork('./func/add_engagement.js');
    handleEngagements.send(req.body);
    handleEngagements.on("message", message => {
      
      var publishInfo = {
        "senderClient": req.body.engagement_profile_id,
        "affectedClient": message['affectedClient'],
        "senderName": message['senderName'],
        "like_dislike": req.body.like_dislike,
        "comment": req.body.comment,
        "followReq": null,
        "postID": req.body.engagement_post_id
      }

      var publishInfoJsonString = JSON.stringify(publishInfo);
      publisher.publish(String(message['affectedClient']), publishInfoJsonString, function(){
        console.log("Finished");
        res.send(String(message));
      });
      // clients.clientList[message].send("YOU HAVE A MESSAGE FROM " + req.body.engagement_profile_id);
      
    });
  });

// Topic follow data methods
app.route("/topicfollowdata")
.get((req, res)=>{
  const handle = fork("./func/get_topic_follow_data.js");
  var data = {
    topic_id: req.query.topic_id,
    flag: req.query.flag
  }
  handle.send(data);
  handle.on("message", message => res.send(message));
})
.post((req, res)=>{
  const handleFollowers = fork("./func/add_topicfollowers.js");

  handleFollowers.send(req.body);
  handleFollowers.on("message", message => res.send(message));
})
.delete((req, res)=> {
  const handle = fork("./func/delete_topic_follower.js");
  handle.send(req.body);
  handle.on("message", message => res.send(message));
});

// User Follow data methods
app.route("/followdata")
  .get((req, res) => {
    const handle = fork("./func/get_follow_data.js");
    var data = {
      profile_id: req.query.profile_id,
      flag: req.query.flag
    }
    handle.send(data);
    handle.on("message", message => res.send(message));
  })
  .post((req, res) => {
    const handle = fork("./func/add_followers.js");
    handle.send(req.body);
    handle.on("message", message => {
      var publisher = redis.createClient(process.env.REDISCLOUD_URL, {no_ready_check: true});
      var publishInfo = {
        "senderClient": req.body.profile_id,
        "affectedClient": req.body.follower_id,
        "senderName": String(message),
        "like_dislike": null,
        "comment": null,
        "followReq": true,
        "postID": null
      }
      console.log(message);
      var publishInfoJsonString = JSON.stringify(publishInfo);
      publisher.publish(String(req.body.follower_id), publishInfoJsonString, function(){
        res.send(String(message));
      });
    });
  })
  .delete((req, res)=> {
    const handle = fork("./func/delete_followers.js");
    handle.send(req.body);
    handle.on("message", message => res.send(message));
  });

//Topic methods  
app.route("/topic")
  .get((req, res) => {
    const handleTopics = fork("./func/get_topic.js");
    var data = {
      topic_id: req.query.topic_id
    }
    handleTopics.send(data);
    handleTopics.on("message", message => res.send(message));
  })
  .post((req, res) => {
    const handtopic = fork('./func/add_topic.js');
    handtopic.send(req.body);
    handtopic.on("message", message => res.send(message));
  })
  .delete((req, res) => {
    const handtopic = fork('./func/delete_topic.js');
    handtopic.send(req.body);
    handtopic.on("message", message => res.send(message));
  });

app.route("/profileMode")
    .post((req, res) => {
      const handleProfileMode = fork('./func/update_profile_mode.js');
      handleProfileMode.send(req.body);
      handleProfileMode.on("message", message => res.send(message));
    });

// User methods
app.route("/user")
.post((req, res) => {
  const handleUser = fork('./func/add_user.js');
  handleUser.send(req.body);
  handleUser.on("message", message => res.send(message));
})
.delete((req, res) => {
  const handleUser = fork('./func/delete_user.js');
  handleUser.send(req.body);
  handleUser.on("message", message => res.send(message));
})

/**
 * Individual end points
 */

// Get all posts for a topic
app.get('/selectposts', (req, res) => {
    const select = fork('./func/select_posts.js');
    var data = {topicID: req.query.topic_id};
    select.send(data);
    select.on("message", message => res.send(message));
  });

// User Follow data methods
app.get("/search",(req, res) =>{
  const handle = fork("./func/search.js");
  var data = {
    text: req.query.text
  }
  handle.send(data);
  handle.on("message", message => res.send(message));
})

// Add engagement for a comment
app.post('/addcommeng', (req, res) => {
  const handleCommentEngagement = fork('./func/add_comment_eng.js');
  handleCommentEngagement.send(req.body);
  handleCommentEngagement.on("message", message => res.send(message));
});

// Get all posts under a topic
app.get('/selectposts', (req, res) => {
  const select = fork('./func/select_posts.js');
  var data = {topicID: req.query.topic_id};
  select.send(data);
  select.on("message", message => res.send(message));
});

// Get topic followed by user count or list
app.get('/userfollowedtopics', (req, res)=> {
  const handleTopics = fork("./func/get_userFollowedTopics.js");
  var data = {
    user_id: req.query.user_id,
    flag: req.query.flag
  }
  handleTopics.send(data);
  handleTopics.on("message", message => res.send(message));
}); 

// Get all comments under a post
app.get('/getcomments', (req, res) => {
  const handleComments = fork("./func/get_comments.js");
  var data = {
    post_id: req.query.post_id
  }
  handleComments.send(data);
  handleComments.on("message", message => res.send(message));
});

// Update topic summary
app.post('/updateTopicDesc', (req, res) => {
  const handle = fork("./func/update_topic_summary.js");
  handle.send(req.body);
  handle.on("message", message => res.send(message));
});
// Refresh user timeline
app.get("/refreshTimeline", (req, res) => {
  const handleRefreshTimeline = fork('./func/refreshTimeline.js');
  console.log("pid forked: "+handleRefreshTimeline.pid);
  var to = setTimeout(function(){
    if(kill_process == true){
      console.log('Killing process: '+handleRefreshTimeline.pid);
      // res.send("Connection killed by server");
      handleRefreshTimeline.kill();
    }
    
  }, 9000);
  data = {
    profileID: req.query.profile_id,
    offset: req.query.post_offset,
    time: req.query.post_time
  }
  handleRefreshTimeline.send(data);
  handleRefreshTimeline.on("message", message => {
    res.send(message);
  });
});
app.get("/getTrendingPosts", (req, res) => {

  const handleTrendingTimeline = fork('./func/get_trending_posts.js');
  console.log("pid forked: "+handleTrendingTimeline.pid);

  var data = {
    "message": "Random"
  }
  handleTrendingTimeline.send(data);
  handleTrendingTimeline.on("message", message => {
    res.send(message);
  });

});
// Refresh topic timeline
app.get("/refreshTopicTimeline", (req, res) => {
  const handleTopicRefreshTimeline = fork('./func/refreshTopicTimeline.js');
  console.log("pid forked: "+ handleTopicRefreshTimeline.pid);
  var to = setTimeout(function(){
    if(kill_process == true){
      console.log('Killing process: '+ handleTopicRefreshTimeline.pid);
      // res.send("Connection killed by server");
      handleTopicRefreshTimeline.kill();
    }
    
  }, 9000);
  data = {
    topicID: req.query.topic_id,
    offset: req.query.post_offset,
    time: req.query.post_time
  };
  handleTopicRefreshTimeline.send(data);
  handleTopicRefreshTimeline.on("message", message => {
    res.send(message);
  });
});

app.post("/addToken", (req, res) => {
  const handleAddToken = fork("./func/add_token.js");
  handleAddToken.send(req.body);
  handleAddToken.on("message", message => res.send(message));
});

app.get("/sendNotif", (req, res) => {
  const handlesendNotif = fork("./func/send_notif.js");
  handlesendNotif.send(req.body);
  handlesendNotif.on("message", message => res.send(message));
});

app.get("/getUserInfo", (req, res) => {
  const handleGetUserInfo = fork("./func/getUserInfo.js");
  var data = {
    profile_id: req.query.profile_id
  };
  handleGetUserInfo.send(data);
  handleGetUserInfo.on("message", message => res.send(message));
});

app.get("/getAllUserPosts", (req, res) => {
  const handleGetAllUserPosts = fork("./func/getAllUserPosts.js");
  var data = {
    profile_id: req.query.profile_id
  }
  handleGetAllUserPosts.send(data);
  handleGetAllUserPosts.on("message", message => res.send(message));
});

app.get("/getFollowingTopics", (req, res) => {
  const handleGetFollowingTopics = fork("./func/getFollowingTopics.js");
  var data = {
    profile_id: req.query.profile_id
  }
  handleGetFollowingTopics.send(data);
  handleGetFollowingTopics.on("message", message => res.send(message));
});

app.get("/getAllPostsWithEngagement", (req, res) => {
  const handleGetAllEngagements = fork("./func/getAllEngagements");
  var data = {
    profile_id: req.query.profile_id
  }
  handleGetAllEngagements.send(data);
  handleGetAllEngagements.on("message", message => res.send(message));
});

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

app.get('/gettrending', (req, res) => {

  const trending = fork('./func/getTrending.js');
    var data = {
      post_id: req.query.post_id,
      flag: req.query.flag
    };
    trending.send(data);
    trending.on("message", message => res.send(message));

});

if(cluster.worker.id == 2){
  var trendingInterval = setInterval(() => {
    console.log("retrieving trending posts...")
    const trending = fork('./func/getTrending.js');
    var data = {
      "tempFlag": "tempVarcls"
    };
    trending.send(data);
  },
  1800000
  );

}
}


  


//Create a fork object - test concurrency only




