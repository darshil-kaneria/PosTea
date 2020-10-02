const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            return console.error("error: " + err.message);
        }
        await addPost(message.str, connection)
    });
});

const addPost = async (userPost, connection) => {
    var userPostMessage = userPost;
    var queryString = "INSERT INTO user_post (post_id, profile_id, post_description, topic_id, post_img, creation_date, post_likes, post_dislikes, post_comments) VALUES ?";
    var curr_date = new Date().toISOString().slice(0, 19).replace('T', ' ');
    var fields = [["02", "03", userPostMessage, "8", "none", curr_date, "13k", "1", "Awesome1!!"]];
    await connection.query(queryString, [fields], (err, result) => {
        if (err) {
            console.log("error: " + err.message);
            throw err;
        }
        console.log("Post added succesfully!!");
        return result;
    });
};

const getPost = async(userPost, userid) => {
    var query = "SELECT * FROM user_post "

}



