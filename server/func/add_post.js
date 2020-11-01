const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }
        var dict = {
            title: message.postTitle,
            post: message.msg,
            topic: message.topic,
            img: message.img,
            topicID: message.topicID,
            profileID: message.profileID,
            likes: message.likes,
            dislikes: message.dislikes,
            comment: message.comment,
            anonymous: message.anonymous,
            is_private: message.is_private
        }
        await addPost(dict, connection).then((answer) => {
            connection.release();
            process.exit();
        }).catch((result) => {
            connection.release();
            process.exit();



        });

    });
});

const addPost = async (dict, connection) => {
    var id = Math.floor(Math.random() * 100000);
    console.log(id)
    var userPostMessage = dict.post;
    var topic = dict.topic
    console.log(topic);
    console.log(dict.topicID);
    var queryTopicExists = "SELECT topic_id, topic_name, COUNT(*) FROM topic_info WHERE topic_name='" + dict.topic + "'";
    var queryString = "INSERT INTO user_post (post_id, profile_id, post_description, topic_id, post_img, creation_date, post_likes, post_dislikes, post_comments, post_title, is_anonymous, is_private) VALUES ?";
    var addTopicContent = "INSERT INTO topic_content (topic_id, post_id) VALUES ?";
    var curr_date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var topicContentFields = [[dict.topicID, dict.profileID]];
<<<<<<< HEAD
    dict.likes = 0;
    dict.dislikes = 0;
    var fields = [[id, dict.profileID, userPostMessage, dict.topicID, dict.img, curr_date, dict.likes, dict.dislikes, dict.comment, dict.title]];
=======
    var fields = [[id, dict.profileID, userPostMessage, dict.topicID, dict.img, curr_date, dict.likes, dict.dislikes, dict.comment, dict.title, dict.anonymous, dict.is_private]];
>>>>>>> 1c70f6c0dc25a2fa28a658b24bf61b20d6fbcb8f

    return new Promise(async (resolve, reject) => {
        await connection.query(queryTopicExists, async (err, result) => {
            if (err) {
                console.log("error: " + err.message);
                reject(err.message);
            }
            result = JSON.stringify(result);
            result = JSON.parse(result);
            console.log(result);
            if (result[0].topic_name == null) {
                flag = 1;
            } else {
                var topic_id = result[0].topic_id;
                fields = [[id, dict.profileID, userPostMessage, topic_id, dict.img, curr_date, dict.likes, dict.dislikes, dict.comment, dict.title, dict.anonymous, dict.is_private]];
                await connection.query(queryString, [fields], (err, result) => {
                    if (err) {
                        if (err.code === 'ER_DUP_ENTRY') {
                            addPost(dict, connection);
                        } else {
                            console.log("error: " + err.message);
                            reject(err.message);   
                        }
                    }
                    console.log("Post added succesfully!!");
                    resolve(result);
                });

                await connection.query(addTopicContent, [topicContentFields], (err, result) => {
                    if (err) {
                        console.log("error: " + err.message);
                        reject(err.message);
                    }
                    console.log("Post information added to topic_content " + topic + " succesfully!!");
                    resolve(result);
                });
            }
            resolve(result);
        });
    })

};





