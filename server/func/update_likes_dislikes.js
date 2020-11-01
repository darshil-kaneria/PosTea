const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }

        var dict = {
            profile_id: message.engagement_profile_id,
            post_id: message.engagement_post_id,
            like_dislike: message.like_dislike
        }

        await updateLikesDislikes(dict, connection).then((answer) => {
            connection.release();
            process.exit();
        });
        // process.send({ "result": result });
        // connection.release();
    });
    // process.exit()
});

updateLikesDislikes = (dict, connection) => {
    query = "SELECT post_id, profile_id, COUNT(*) FROM engagement WHERE post_id = " + String(dict.post_id) + ", profile_id = " + String(dict.profile_id);
     
};