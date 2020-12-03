const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            // connection.release();
            return console.error("error: " + err.message);
        }

        search(message.text, connection).then((result) => {
            console.log(result);
            process.send(result);
            //connection.release();
            process.exit();
          }).catch((reject) => {
            console.log("reject");
            process.send(reject);
            //connection.release();
            process.exit();
          });
        // process.send({ "result": result });
        // connection.release();
    });
    // process.exit()
});

const search = (text, connection) => {
    var string = text + "*";
    console.log(string);
    var query1 = "SELECT profile_id, name FROM profile WHERE  MATCH(name) Against('"+string+"' in boolean mode)"
    var query2 = "SELECT topic_id, topic_name FROM topic_info WHERE  MATCH(topic_name) Against('"+string+"' in boolean mode)"
    var topics = [];
    var profiles = [];
    

    return new Promise(async function(resolve, reject) {
        await connection.query(query1,  async function (err, result) {
            if (err) {
                reject(err.message);
            }
            console.log("res");
            //console.log(result);
            
            if (result.length > 0) {
                
                for (var i = 0; i < result.length; i++) {
                    result[i].type = "profile";
                    profiles.push(result[i]);

                }
                
                console.log(profiles);
                

            }
            await connection.query(query2,  function (err, result) {
                if (err) {
                    reject(err.message);
                }
                if (result.length > 0) {
                    for (var i = 0; i < result.length; i++) {
                        result[i].type = "topic";
                        profiles.push(result[i]);
    
                    }
                    var topics = result;
                    console.log(topics);
                    
    
                }
                
                resolve(profiles);
    
            });
            

        });
        
        



    });


}