
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          if (message.flag == "likes") {
            get_likes(message.post_id, message.flag, connection).then((value)=> {
                process.send({"likes": value.length});
                connection.release();
                process.exit();
            }).catch(function(result) {
                process.send(result);
                connection.release();
                process.exit();

            });
        } else if (message.flag == "dislikes") {
            get_dislikes(message.post_id, message.flag, connection).then((value)=> {
                process.send({"dislikes": value});
                connection.release();
                process.exit();
            }).catch(function(result) {
                process.send(result);
                connection.release();
                process.exit();

            });
        }          
    });
});

const get_likes = async(post_id, connection) => {
    var query = "SELECT * FROM engagement WHERE engagement.post_id = ? AND engagement.like_or_dislike = ?";
    var like = 1;
    return new Promise(function(resolve, reject) {
    connection.query(query,[post_id, like],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                console.log(result);
                reject("0");
            } else {
                console.log(result);
                resolve(result);
            }
        });
    });
}

const get_dislikes = async(post_id, connection) => {
    var query = "SELECT * FROM engagement WHERE engagement.post_id = ? AND engagement.like_or_dislike = ?";
    return new Promise(function(resolve, reject) {
       connection.query(query,[post_id, 0],function(err, result)  {
            if (err) {
                console.log("error:" + err.message);
                reject(err.message);
            }
            if (result.length == 0) {
                reject("0");
            } else {
                console.log(result);
                resolve(result.length);
            }
        });
    });
}