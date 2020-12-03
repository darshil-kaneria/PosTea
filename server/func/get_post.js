const db = require('./db_connection.js');

process.on("message", message => {
  db.conn.getConnection(async function (err, connection) {
    if (err) {
      return console.error('error: ' + err.message);
    }
    console.log('Database connection established');
    await getPost(message.post_id, connection).then((answer) => {
      connection.release();
      process.send(answer);
      process.exit();
    });


  });
});

const getPost = async (postId, connection) => {
  var query = "SELECT * FROM user_post as up, profile as p WHERE up.post_id = ? and up.profile_id = p.profile_id";
  return new Promise(async function (resolve, reject) {
    await connection.query(query, [postId], async function (err, result) {
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
          result[0].username = "Anonymous";
        } else {
          await convert_to_username(result[0], connection).then((value) => {
            console.log(value);
            result[0].username = value[0].username;
          });
        }
        var timeDiff = "";
        var currentDate = new Date();
        // console.log(currentDate.getDay())
        var postDate = new Date(result[0].creation_date);
        if (currentDate.getDay() - postDate.getDay() > 1) {
          timeDiff = (currentDate.getDay() - postDate.getDay()) + " days ago";
        }
        else if (currentDate.getHours() - postDate.getHours() > 1) {
          timeDiff = (currentDate.getHours() - postDate.getHours()) + " hours ago";
        }
        else if (currentDate.getMinutes() - postDate.getMinutes() > 1) {
          timeDiff = (currentDate.getMinutes() - postDate.getMinutes()) + " min. ago";
        }
        else if (currentDate.getSeconds() - postDate.getSeconds() > 1) {
          timeDiff = (currentDate.getSeconds() - postDate.getSeconds()) + "s ago";
        }
        var myJSON = JSON.stringify(result);
        var temp = myJSON.substring(0, myJSON.length - 2);
        var string = "\"time_diff\":" + "\"" + timeDiff + "\"";
        temp = temp + "," + string + "}]";
        var final_result = JSON.parse(temp);
        var post_description = final_result[0].post_description;
        if (typeof post_description !== 'undefined' && post_description != null) {
          if (post_description.includes("@")) {
            var index_of_at = post_description.indexOf("@");
            if (index_of_at >= 0 && post_description.charAt(index_of_at - 1) == ' ') {
              var tag = post_description.substring(index_of_at, post_description.length);
              var index_of_space = tag.indexOf(" ");
              if (index_of_space == -1) {
                index_of_space = tag.length - 1;
              }
              var tag = tag.substring(1, index_of_space + 1);
              await get_updated_result(final_result[0], tag, connection).then((value) => {
                final_result = value;
              });
            } else {
              // result[i]["flag"] = "No tag";
            }
          } else {
            // result[i]["flag"] = "No tag";
          }
        } else {
          // result[i]["flag"] = "No tag";
        }
      }
      final_result = JSON.stringify(final_result);
      final_result = JSON.parse(final_result);
      resolve(final_result);
    });
    // return result;  
  });
}


const get_updated_result = async (current_result, tag, connection) => {
  var new_field = "";
  var id = 0;
  var selectQuery1 = "SELECT profile_id FROM profile WHERE profile.username = ?";
  return new Promise(async function (resolve, reject) {
    await connection.query(selectQuery1, [tag], async function (err, result) {
      if (err) {
        console.log("error exists");
        reject(err.message);
      }
      else {
        if (result.length == 0) {
          await get_updated_result1(current_result, tag, connection).then((value) => {
            current_result = value;
          });
        } else {
          new_field = "profile_id";
          id = result[0].profile_id;
          if (new_field == "") {
            current_result["flag"] = "No tag";
          } else {
            current_result["tag_id"] = id;
            current_result["flag"] = "Tag exists: profile_id";
          }
        }

        current_result = JSON.stringify(current_result);
        current_result = JSON.parse(current_result);
        resolve(current_result);
      }
    });
  });
}

const get_updated_result1 = async (current_result, tag, connection) => {
  var new_field = "";
  var id = 0;
  var selectQuery1 = "SELECT topic_id FROM topic_info WHERE topic_info.topic_name = ?";
  return new Promise(function (resolve, reject) {
    connection.query(selectQuery1, [tag], function (err, result) {
      if (err) {
        console.log("error exists");
        reject(err.message);
      }
      else {
        if (result.length == 0) {
          current_result["flag"] = "Incorrect tag";
        } else {
          new_field = "topic_id";
          id = result[0].topic_id;
          if (new_field == "") {
            current_result["flag"] = "No tag";
          } else {
            current_result["tag_id"] = id;
            current_result["flag"] = "Tag exists: topic_id";
          }
        }

        current_result = JSON.stringify(current_result);
        current_result = JSON.parse(current_result);
        resolve(current_result);
        // return result;  
      }
    });
  });
}

const convert_to_username = async (id, connection) => {
  var query1 = "SELECT username FROM profile WHERE profile.profile_id = ?";
  return new Promise(function (resolve, reject) {
    connection.query(query1, [id.profile_id], function (err, result) {
      if (err) {
        console.log("error exists");
        reject(err.message);
      }
      else {
        result = JSON.stringify(result);
        result = JSON.parse(result);
        console.log(result)
        resolve(result);
        // return result;  
      }
    });
  });
}