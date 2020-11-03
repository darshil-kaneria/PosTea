const db = require('./db_connection.js');


process.on("message", message => {
  db.conn.getConnection(async (err, connection) => {
    if (err) {
      return console.error('error: ' + err.message);
    }

    console.log('Database connection established');
    var data = {
      engagement_post_id : message.engagement_post_id,
      engagement_profile_id : message.engagement_profile_id,
      like_dislike : message.like_dislike,
      comment : message.comment

    }
    await addEngagement(message, connection).then((answer) => {

      connection.release();
      process.send(answer);
      process.exit();
    }).catch ((result) => {
      connection.release();
      // process.send({"result": "Sent engagement"});
      process.exit();
    }).catch((err) => {
      console.log("In Error, Oops");
    });
  });
});

const addEngagement = async (dict, connection) => {
  console.log(dict)
  var existsQuery = "SELECT * FROM engagement WHERE post_id = " + String(dict.engagement_post_id) + " AND profile_id = " + String(dict.engagement_profile_id);
  var engagementID = Math.floor(Math.random() * 100000);
  var updatequery = "UPDATE user_post SET post_likes = post_likes + 1 WHERE post_id = ?";
  var updateQuery2 = "UPDATE user_post SET post_dislikes = post_dislikes + 1 WHERE post_id = ?";
  var like_dislike_null = false;
  var commet_null = false;

  var curr_date = new Date().toISOString().slice(0, 19).replace('T', ' ');

  return new Promise(async (resolve, reject) => {

    // Check if user has engaged with the post before.
    await connection.query(existsQuery, async (err, result) => {

      if(err){
        
        reject(err.message);
      }

      result = JSON.stringify(result);
      result = JSON.parse(result);

      if(!Object.keys(result).length){
        // User has not engaged with the post. So create a new engagement depending on what the user wants to do.
        var addEngagementQuery = "INSERT INTO engagement (engagement_id, post_id, profile_id, like_or_dislike, creation_date) VALUES ?";
        var vals = [[engagementID, dict.engagement_post_id, dict.engagement_profile_id, dict.like_dislike, curr_date]];
        if(dict.like_dislike == null){
          // Want to comment
          vals = [[engagementID, dict.engagement_post_id, dict.engagement_profile_id, dict.comment, curr_date]];
          addEngagementQuery = "INSERT INTO engagement (engagement_id, post_id, profile_id, comment, creation_date) VALUES ?";
        }
        else if(dict.comment == null){
          // Want to like_dislike
          vals = [[engagementID, dict.engagement_post_id, dict.engagement_profile_id, dict.like_dislike, curr_date]];
          addEngagementQuery = "INSERT INTO engagement (engagement_id, post_id, profile_id, like_or_dislike, creation_date) VALUES ?";
        }
        await connection.query(addEngagementQuery, [vals], async (err, result) => {
          if(err){
            reject(err.message);
          }

          // Update in the user_post table accordingly

          if(dict.like_dislike == "1"){
            // add like to userpost
            var updatequery = "UPDATE user_post SET post_likes = post_likes + 1 WHERE post_id = " + String(dict.engagement_post_id);
            await connection.query(updatequery, async (err, result) => {
              if(err){
                reject(err.message);
              }

              console.log("Like updated in userpost");
              resolve(result);
            });
          }
          else if(dict.like_dislike == "0"){
            // add dislike to userpost
            var updatequery = "UPDATE user_post SET post_dislikes = post_dislikes + 1 WHERE post_id = " + String(dict.engagement_post_id);
            await connection.query(updatequery, async (err, result) => {
              if(err){
                reject(err.message);
              }

              console.log("Dislike updated in userpost");
              resolve(result);
            });

          }
          else if(dict.comment != null){
            // add comment count to userpost
            var updatequery = "UPDATE user_post SET post_comments = post_comments + 1 WHERE post_id = " + String(dict.engagement_post_id);
            await connection.query(updatequery, async (err, result) => {
              if(err){
                reject(err.message);
              }

              console.log("Comments updated in userpost");
              resolve(result);
            });

          }

          console.log("like dislike: "+dict.like_dislike+", comment: "+dict.comment);

        });
      }
      else{
        console.log(result);
        // Engagement already exists. Either delete or update according to what the user wants.
        if(dict.like_dislike == 1 && result[0]['like_or_dislike'] == "0"){
          var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.like_or_dislike = " + String(dict.like_dislike) + ", user_post.post_likes = user_post.post_likes + 1, user_post.post_dislikes = user_post.post_dislikes - 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
          await connection.query(updateQuery, async (err, result) => {
            if(err){
              reject(err.message);
            }

            console.log(result);
            resolve(result);
          });
        }
        else if(dict.like_dislike == 0 && result[0]['like_or_dislike'] == "1"){
          var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.like_or_dislike = " + String(dict.like_dislike) + ", user_post.post_likes = user_post.post_likes - 1, user_post.post_dislikes = user_post.post_dislikes + 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
          await connection.query(updateQuery, async (err, result) => {
            if(err){
              reject(err.message);
            }
            console.log("HERE");
            console.log(result);
            resolve(result);
          });
        }
        else if((dict.like_dislike == 0 || dict.like_dislike == 1) && result[0]['like_or_dislike'] == null){
          if(dict.like_dislike == 1){
            var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.like_or_dislike = " + String(dict.like_dislike) + ", user_post.post_likes = user_post.post_likes + 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
            await connection.query(updateQuery, async (err, result) => {
              if(err){
                reject(err.message);
              }
              resolve(result);
            });
          }
          else if(dict.like_dislike == 0){
            var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.like_or_dislike = " + String(dict.like_dislike) + ", user_post.post_dislikes = user_post.post_dislikes + 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
            await connection.query(updateQuery, async (err, result) => {
              if(err){
                reject(err.message);
              }
              resolve(result);
            });
          }

        }
        else if(String(dict.like_dislike) == result[0]['like_or_dislike']){
          // Check unlike or undislike
          var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.like_or_dislike = " + String(dict.like_dislike) + ", user_post.post_dislikes = user_post.post_dislikes + 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
          if(result[0]['like_or_dislike'] == "1"){
            var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.like_or_dislike = NULL, user_post.post_likes = user_post.post_likes - 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
          }
          else if(result[0]['like_or_dislike'] == "0"){
            var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.like_or_dislike = NULL, user_post.post_dislikes = user_post.post_dislikes - 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
          }
          var tempResult = result;
          await connection.query(updateQuery, async (err, result) => {
            // Check if comments is empty. If empty, then remove the entire engagement.
            if(err){
              reject(err.message);
            }
            if(tempResult[0]['comment'] == null){
              // remove entire entry from engagement
              var delQuery = "DELETE FROM engagement WHERE post_id = "+String(dict.engagement_post_id)+" AND profile_id="+String(dict.engagement_profile_id);
              await connection.query(delQuery, async (err, result) => {
                if(err){
                  reject(err.message);
                }
                resolve(result);
              });
            }
            else{
              resolve(result);
            }
          });
          
          
        }
        else if(dict.comment == null && result[0]['comment'] != null){

          var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date='" +curr_date+"', engagement.comment = NULL, user_post.post_comments = user_post.post_comments - 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
          await connection.query(updateQuery, async (err, result)=> {
            if(err){
              reject(err.message);
            }
            if(result[0]['like_or_dislike'] == null){
              var delQuery = "DELETE FROM engagement WHERE post_id = "+String(dict.engagement_post_id)+" AND profile_id="+String(dict.engagement_profile_id);
              await connection.query(delQuery, async (err, result) => {
                if(err){
                  reject(err.message);
                }
                resolve(result);
              });
            }
          });
        }
        else if(dict.comment != null && result[0]['comment'] == null){
          var updateQuery = "UPDATE engagement, user_post SET engagement.creation_date=\"" +curr_date+"\", engagement.comment = \""+String(dict.comment)+"\", user_post.post_comments = user_post.post_comments + 1 WHERE engagement.post_id = " + String(dict.engagement_post_id) + " AND engagement.profile_id = " + String(dict.engagement_profile_id) + " AND user_post.post_id = "+String(dict.engagement_post_id);
          await connection.query(updateQuery, async (err, result) => {
            if(err){
              reject(err.message);
            }
            resolve(result);
          });
        }
      }

    });

  });
}