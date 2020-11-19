const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            // connection.release();
            return console.error("error: " + err.message);
        }

        await search(message.text, connection).then((result) => {
            connection.release();
            process.send(result);
            process.exit();
          }).catch((reject) => {
            connection.release();
            process.send(reject);
            process.exit();
          });
        // process.send({ "result": result });
        // connection.release();
    });
    // process.exit()
});

const search = async(text, connection) => {
    var string = text + "*";
    var query1 = "SELECT profile_id, name FROM profile WHERE  MATCH(name) Against('"+string+"' in boolean mode)"
    var query2 = "SELECT topic_id, topic_name FROM profile WHERE  MATCH(topic_name) Against('"+string+"' in boolean mode)"
    var topics = [];
    var profiles = [];
    

    return new Promise(async function(resolve, reject) {
        await connection.query(query1,  async function (err, result) {
            if (err) {
                reject(err.message);
            }
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    result[i].type = "profile";

                }
                var profiles = result;
                

            }

        });
        await connection.query(query2,  async function (err, result) {
            if (err) {
                reject(err.message);
            }
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    result[i].type = "topic";

                }
                var topics = result;
                

            }

        });
        var results = profiles.concat(topics);
        resolve(results);



    });


}