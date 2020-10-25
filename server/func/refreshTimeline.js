//const { query } = require('express');
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            // connection.release();
            return console.error("error: " + err.message);
        }

        refreshTimeline(message.profileID, message.offset, connection).then((answer) => {
            connection.release();
            console.log("Exiting process: "+process.pid);
            process.exit();
        });
        // process.send({ "result": result });
        // connection.release();
    });
    // process.exit()
});

refreshTimeline = async (profileID, offset, connection) => {
    var getNumPosts = "SELECT profile_id, COUNT(*) FROM user_post WHERE profile_id = " + String(profileID);
    var query = "SELECT * FROM user_post WHERE profile_id = " + String(profileID) + " ORDER BY creation_date DESC LIMIT " + String(offset) + ", 3"; // change if condition below if you change limit
    return new Promise(async (resolve, reject) => {
        await connection.query(getNumPosts, async (err, result) => {
            if (err) {
                console.log(err);
                reject(err.message);
            }
            result = JSON.stringify(result);
            // result = JSON.parse(result);
            var numOccurances = result.substring(28, result.indexOf("}"));
            if (offset >= numOccurances - 2) { // change if you change limit
                var limit = numOccurances - offset;
                var newquery = "SELECT * FROM user_post WHERE profile_id = " + String(profileID) + " ORDER BY creation_date DESC LIMIT " + String(offset) + ", " + String(limit); // change if condition below if you change limit
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
            } else {
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
            return result;
        });
    });
};