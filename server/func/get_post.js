const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getPost(message.post_id, connection).then((answer)=> {
            connection.release();
            process.send(answer);
            process.exit();
          });
          
          
        });
});

const getPost = async(postId, connection) => {
    var query = "SELECT * FROM user_post WHERE user_post.post_id = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[postId],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log("Post does not exist");
            } else {
                console.log("Post retrieved");
                if (result[0].is_anonymous == 1) {
                    result[0].profile_id = -1;
                }
                var timeDiff = "";
                var currentDate = new Date();
                // console.log(currentDate.getDay())
                var postDate = new Date(result[0].creation_date);
                    if(currentDate.getDay() - postDate.getDay() > 1){
                        timeDiff = (currentDate.getDay() - postDate.getDay()) + " days ago";
                    }
                    else if(currentDate.getHours() - postDate.getHours() > 1){
                        timeDiff = (currentDate.getHours() - postDate.getHours()) + " hours ago";
                    }
                    else if(currentDate.getMinutes() - postDate.getMinutes() > 1){
                        timeDiff = (currentDate.getMinutes() - postDate.getMinutes()) + " min. ago";
                    }
                    else if(currentDate.getSeconds() - postDate.getSeconds() > 1){
                        timeDiff = (currentDate.getSeconds() - postDate.getSeconds()) + "s ago";
                    }
                    var myJSON = JSON.stringify(result);
                    var temp = myJSON.substring(0, myJSON.length-2);
                    var string = "\"time_diff\":"+"\""+timeDiff+"\"";
                    temp = temp+","+string+"}]";
                    var final_result = JSON.parse(temp);
                    resolve(final_result);
                }
                // return result;  
        });
    });
}