const { query } = require('express');
const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }

        await refreshTimeline(message.profileID, connection).then((answer) => {
            connection.release();
            process.exit();
        });
        // process.send({ "result": result });
        // connection.release();
    });
    // process.exit()
});

refreshTimeline = async (profileID, connection) => {
    var query = "SELECT post_description, topic_id, post_img, creation_date, post_likes, post_dislikes, post_comments FROM user_post WHERE profile_id = " + String(profileID) + " ORDER BY creation_date DESC LIMIT 100";
    return new Promise(async (resolve, reject) => {
        await connection.query(query, (err, result) => {
            if (err) {
                console.log("error: " + err.message);
                throw err;
            }
            result = JSON.stringify(result);
            result = JSON.parse(result);
            // var list = [];
            // for (i = 0; i < length(result); i++) {
    
            // }
            process.send({ "result": result });
            console.log(result);
            return result;
        });
    })
};