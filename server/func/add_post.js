const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }
        var dict = {
            post: message.msg,
            topic: message.topic,
            topicID: message.topicID,
            postID: message.postID,
            profileID: message.profileID,
            likes: message.likes,
            dislikes: message.dislikes,
            comment: message.comment
        }
        await addPost(dict, connection);
    });
});

const addPost = async (dict, connection) => {
    var userPostMessage = dict.post;
    var topic = dict.topic
    var queryTopicExists = "SELECT topic_id, topic_name, COUNT(*) FROM topic_info WHERE topic_name='" + dict.topic + "'";
    var queryString = "INSERT INTO user_post (post_id, profile_id, post_description, topic_id, post_img, creation_date, post_likes, post_dislikes, post_comments) VALUES ?";
    var addTopicContent = "INSERT INTO topic_content (topic_id, post_id) VALUES ?";
    var curr_date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var topicContentFields = [[dict.topicID, dict.profileID]];
    var fields = [[dict.postID, dict.profileID, userPostMessage, dict.topicID, "none", curr_date, dict.likes, dict.dislikes, dict.comment]];
    
    await connection.query(queryTopicExists, async (err, result) => {
        if (err) {
            console.log("error: " + err.message);
            throw err;
        }
        result = JSON.stringify(result);
        result = JSON.parse(result);
        console.log(result);
        if (result[0].topic_name == null) {
            flag = 1;
        } else {
            await connection.query(queryString, [fields], (err, result) => {
                if (err) {
                    console.log("error: " + err.message);
                    throw err;
                }
                console.log("Post added succesfully!!");
                return result;
            });
            
            await connection.query(addTopicContent, [topicContentFields], (err, result) => {
                if (err) {
                    console.log("error: " + err.message);
                    throw err;
                }
                console.log("Post information added to topic_content " + topic + " succesfully!!");
                return result;
            });
        }
        return result;
    });
    

};




