










const getPost = async(userPost, userid) => {
    var query = "SELECT * FROM user_post Where user_post.post_id = ? VALUE";

    await connection.query(query,[userid],function(err, result)  {
        if (err) {
            console.log("error:" + err.message);
            throw err;
        }

        
    });



}