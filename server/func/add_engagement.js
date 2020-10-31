const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(async (err, connection) => {
    if (err) {
      return console.error('error: ' + err.message);
    }

    console.log('Database connection established');
    await addEngagement(message, connection).then((answer) => {
      connection.release();
      // process.send({"result": "Sent engagement"});
      process.exit();
    }).catch((err) => {
      console.log("In Error, Oops");
    });

  });
});

const addEngagement = async (dict, connection) => {
  var existsQuery = "SELECT post_id, profile_id, COUNT(*) FROM engagement WHERE post_id = " + String(dict.engagement_post_id) + " AND profile_id = " + String(dict.engagement_profile_id);
  var engagementID = Math.floor(Math.random() * 100000);
  var curr_date = new Date().toISOString().slice(0, 19).replace('T', ' ');
  return new Promise(async (resolve, reject) => {
    // Check to see if the user has engaged with the post before
    await connection.query(existsQuery, async (err, result) => {
      if (err) {
        console.log(err);
        reject(err.message);
      }
      result = JSON.stringify(result);
      var isNull = result.substring(12, 16);
      if (isNull != "null") { // user has engaged with the post before
        // Check how the user has engaged with the post currently
        if ('like_dislike' in dict) { // User has liked/disliked the post
          var checkNull = "SELECT like_or_dislike FROM engagement WHERE post_id = " + String(dict.engagement_post_id) + " AND profile_id = " + String(dict.engagement_profile_id);
          await connection.query(checkNull, async (err, result) => {
            if (err) {
              console.log(err);
              reject(err.message);
            }
            result = JSON.stringify(result);
            result = JSON.parse(result);
            // check to see if user has previously liked or disliked the post
            //if (result.like_or_dislike != null) { // If user has liked/disliked the post previously, then update the value
            updateQuery = "UPDATE engagement SET creation_date='" +curr_date+"', like_or_dislike = " + String(dict.like_dislike) + " WHERE post_id = " + String(dict.engagement_post_id) + " AND profile_id = " + String(dict.engagement_profile_id);
            await connection.query(updateQuery, (err, result) => {
              if (err) {
                console.log(err);
                reject(err.message);
              }
              console.log("Successfully updated like_or_dislike field of engagement table!")
              resolve(result);
            });
          });
        } else { // User has commented on the post
          var checkNull = "SELECT comment FROM engagement WHERE post_id = " + String(dict.engagement_post_id) + " AND profile_id = " + String(dict.engagement_profile_id);
          await connection.query(checkNull, async (err, result) => {
            if (err) {
              console.log(err);
              reject(err.message);
            }
            result = JSON.stringify(result);
            result = JSON.parse(result);
            //if (result.comment != null) { // If user has previously commented on this post, then update value
            var updateQuery2 = `UPDATE engagement SET creation_date='${curr_date}', comment = "${dict.comment}" WHERE post_id = ${String(dict.engagement_post_id)} AND profile_id = ${String(dict.engagement_profile_id)}`;
            await connection.query(updateQuery2, (err, result) => {
              if (err) {
                console.log(err);
                reject(err.message);
              }
              console.log("Successfully updated comment field of engagement table!")
              resolve(result);
            })
          })
        }
      } else { // User has not engaged with this post before. Add new entry in engagement table in database.
        
        if ('like_dislike' in dict) {
          var vals = [[engagementID, dict.engagement_post_id, dict.engagement_profile_id, dict.like_dislike, curr_date]];
          var addEngagementQuery = "INSERT INTO engagement (engagement_id, post_id, profile_id, like_or_dislike, creation_date) VALUES ?";
        } else {
          var vals = [[engagementID, dict.engagement_post_id, dict.engagement_profile_id, dict.comment, curr_date]];
          var addEngagementQuery = "INSERT INTO engagement (engagement_id, post_id, profile_id, comment, creation_date) VALUES ?";
        }

        await connection.query(addEngagementQuery, [vals], (err, result) => {
          if (err) {
            console.log(err);
            reject(err.message);
          }
          console.log("Engagement Recorded Successfully!");
          resolve(result);
        });
      }
      // resolve(result);
    });
  });


}