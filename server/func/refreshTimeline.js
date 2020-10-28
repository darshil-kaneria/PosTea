//const { query } = require('express');
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            // connection.release();
            return console.error("error: " + err.message);
        }

        refreshTimeline(message.profileID, message.offset, message.time, connection).then((answer) => {
            connection.release();
            console.log("Exiting process: "+process.pid);
            process.exit();
        });
        // process.send({ "result": result });
        // connection.release();
    });
    // process.exit()
});

refreshTimeline = async (profileID, offset, time, connection) => {

    var followingList = [];
    var followingListString;
    var getOffset;
    var isTimeNull = false;
   
    console.log(time);
    //QUERY 1 - to select the dynamic offset
    
    var getFollowing = `SELECT * FROM user_follower WHERE user_follower.profile_id = ${profileID}`;
    
    // var query = "SELECT * FROM user_post WHERE profile_id = " + String(profileID) + " ORDER BY creation_date DESC LIMIT " + String(offset) + ", 3"; // change if condition below if you change limit
    return new Promise(async (resolve, reject) => {
        await connection.query({sql: getFollowing, timeout: 7000}, async (err, result) => {

            if(err){
                reject(err.message);
            }
            for(var i = 0; i < result.length; i++){
                followingList.push(parseInt(result[i].follower_id));
            }
            console.log(followingList);
            followingListString = followingList.join(',');
            followingListString = "("+followingListString+")";
            console.log(followingListString);

            if(time == null){
                // getOffset = `SELECT COUNT(*) as offs FROM user_post WHERE profile_id in ${followingListString} ORDER BY creation_date DESC`;
                isTimeNull = true;
                
            }

            var getNumPosts = "SELECT profile_id, COUNT(*) FROM user_post WHERE profile_id in " +followingListString;
                await connection.query(getNumPosts, async (err, result) => {
                        if (err) {
                            console.log(err);
                            reject(err.message);
                        }
                        result = JSON.stringify(result);
                        // result = JSON.parse(result);
                        var numOccurances = result.substring(28, result.indexOf("}"));
                        if(isTimeNull){

                            var query = "SELECT * FROM user_post WHERE profile_id in "+followingListString+" ORDER BY creation_date DESC LIMIT " + String(offset) + ", 3"; // change if condition below if you change limit
                            await connection.query({sql: query, timeout: 7000}, (err, result) => {
                            if (err && err.code === 'PROTOCOL_SEQUENCE_TIMEOUT') {
                                var dict = {
                                    "error": 2
                                }
                                process.send(dict);
                                throw new Error('Request timed out after 15 seconds');
                              }
                            if (err) {
                                console.log("error: " + err.message);
                                reject(err.message);
                            }
            
                            result = JSON.stringify(result);
                            result = JSON.parse(result);
                            // var list = [];
                            // for (i = 0; i < length(result); i++) {
            
                            // }
                            var dict = {
                                "result": result,
                                "error": 0
                            }
                            process.send(dict);
                            console.log("Query complete");
                            // connection.release();
                            resolve(result);
                        });

                        }
                        var getOffset = `SELECT COUNT(*) as offs FROM user_post WHERE profile_id in ${followingListString} AND creation_date > ${time} ORDER BY creation_date DESC`;   
                     
                    // GET FOLLOWING LIST
                    await connection.query({sql: getOffset, timeout: 7000}, [time], async (err, result) => {
                        
                        
                            if (err) {
                            reject(err.message)
                        }
                        // result = JSON.stringify(result);
                        // result = JSON.parse(result);
                        console.log("result is .....");
                        console.log(result[0].offs);
                        console.log(offset);
                        offset = parseInt(result[0].offs) + parseInt(offset);
                        console.log(offset);
                         
                        if (offset >= numOccurances - 2) { // change if you change limit
                            var limit = numOccurances - offset;
                            var newquery = "SELECT * FROM user_post WHERE profile_id in " +followingListString+ " ORDER BY creation_date DESC LIMIT " + String(offset) + ", " + String(limit); // change if condition below if you change limit
                            await connection.query({sql: newquery, timeout: 7000}, (err, result) => {
                                if (err && err.code === 'PROTOCOL_SEQUENCE_TIMEOUT') {
                                    var dict = {
                                        "error": 2
                                    }
                                    process.send(dict);
                                    reject('Request timed out after 15 seconds');
                                  }
                                if (err) {
                                    console.log("error: " + err.message);
                                    reject(err.message);
                                }
                
                                result = JSON.stringify(result);
                                result = JSON.parse(result);
                                // var list = [];
                                // for (i = 0; i < length(result); i++) {
                
                                // }
                                var dict = {
                                    "result": result,
                                    "error": 1
                                }
                                process.send(dict);
                                console.log("Query Complete");
                                // connection.release();
                                resolve(result);
                            });
                        }
                        else{

                            var query = "SELECT * FROM user_post WHERE profile_id in "+followingListString+" ORDER BY creation_date DESC LIMIT " + String(offset) + ", 3"; // change if condition below if you change limit
                        await connection.query({sql: query, timeout: 7000}, (err, result) => {
                        if (err && err.code === 'PROTOCOL_SEQUENCE_TIMEOUT') {
                            var dict = {
                                "error": 2
                            }
                            process.send(dict);
                            throw new Error('Request timed out after 15 seconds');
                          }
                        if (err) {
                            console.log("error: " + err.message);
                            reject(err.message);
                        }
        
                        result = JSON.stringify(result);
                        result = JSON.parse(result);
                        // var list = [];
                        // for (i = 0; i < length(result); i++) {
        
                        // }
                        var dict = {
                            "result": result,
                            "error": 0
                        }
                        process.send(dict);
                        console.log("Query complete");
                        // connection.release();
                        resolve(result);
                    });

                        }

                        
                        
                    });
                    
                    
                    // resolve(result);
                });
           
            
            return result;
        });
    });
};