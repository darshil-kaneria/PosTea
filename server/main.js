/**
 * This file is divided into two parts; User endpoints and Dev endpoints. The former are supposed to be used to communicate with the user and
 * the database while the latter are supposed to be used as dev tools only.
 * To allow for a larger request processing capacity, each function must be added in a seperate file and should be forked into a new child when needed.
 * Do not exceed more than 255 processes since that is how many processes heroku supplies with the free dyno that we are currently running.
 */
const cluster = require('cluster');
const express = require('express');
const app = express();
app.use(express.static("dir"));
app.use(express.json({limit: '2mb'}));
const PORT = process.env.PORT || 23556;
const numCPUs = require('os').cpus().length;
var cors = require('cors');

var lastWorkerPID = -1;

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
  app.use(cors({
    origin: ["http://localhost:23556"],
    credentials: true
  }))
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
    handleEngagements.on("message", message => res.send(message));
  });
  // TODO
  /*.delete((req, res)=> {
    const handle = fork("./func/delete_engagement.js");
    handle.send(req.body);
    handle.on("message", message => res.send(message));

  });*/

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
})

// User Follow data methods

app.get("/search",(req, res) =>{
  const handle = fork("./func/search.js");
  var data = {
    text: req.query.text
  }
  handle.send(data);
  handle.on("message", message => res.send(message));
  
})
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
    handle.on("message", message => res.send(message));
  })
  .delete((req, res)=> {
    const handle = fork("./func/delete_followers.js");
    handle.send(req.body);
    handle.on("message", message => res.send(message));
  });

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

// Add new user
app.post('/adduser', (req, res) => {
  const handlePosts = fork('./func/add_user.js');
  handlePosts.send(req.body);
  handlePosts.on("message", message => res.send(message));
});

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
    console.log('Killing process: '+handleRefreshTimeline.pid);
    // res.send("Connection killed by server");
    handleRefreshTimeline.kill();
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
    console.log('Killing process: '+ handleTopicRefreshTimeline.pid);
    // res.send("Connection killed by server");
    handleTopicRefreshTimeline.kill();
  }, 9000);
  data = {
    topicID: req.query.topic_id,
    offset: req.query.post_offset,
    time: req.query.post_time
  }
  handleTopicRefreshTimeline.send(data);
  handleTopicRefreshTimeline.on("message", message => {
    res.send(message);
  });
});

app.listen(PORT, ()=>console.log("listening on port "+PORT+", PID: "+process.pid));

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




