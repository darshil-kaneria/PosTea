document.getElementById("btn1").onclick = () => {
    var post = document.getElementById("text").value;
    var topic = document.getElementById("topicText").value;
    // var postID = document.getElementById("postID").value;
    var profileID = document.getElementById("profileID").value;
    var topicID = document.getElementById("topicID").value;
    var likes = document.getElementById("likes").value;
    var dislikes = document.getElementById("dislikes").value;
    var img = document.getElementById("img").value;
    var comment = document.getElementById("postComments").value;
    var postTitle = document.getElementById("postTitle").value;

    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ msg: post, topic: topic, postTitle: postTitle, profileID: profileID, img: img, topicID: topicID, likes: likes, dislikes: dislikes, comment: comment})
    };
    fetch("/makePost", options);
    alert("Request to add post sent successfully.");
};

document.getElementById("btn2").onclick = () => {
    var topicID = document.getElementById("topic_id").value;
    var topicCreatorID = document.getElementById("topic_creator_id").value;
    var topicText = document.getElementById("newTopicText").value;
    var topicDescription = document.getElementById("topic_description").value;

    console.log(topicCreatorID);
    console.log(topicDescription);
    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ topicText: topicText, topicID: topicID, topicCreatorID: topicCreatorID, topicDescription: topicDescription})
    };
    fetch("/addTopicInfo", options);
    alert("Request to add topic sent successfully.");
};

document.getElementById("newUserBtn").onclick = () => {
    var newUser = document.getElementById("newUser").value;
    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({newUser: newUser})
    };
    fetch("/adduser", options);
    alert("Request to add user sent successfully.");
};

document.getElementById("addProfile").onclick = () => {
    var username = document.getElementById("username").value;
    var privateAcc = document.getElementById("privateAcc").value;
    var name = document.getElementById("name").value;
    var biodata = document.getElementById("biodata").value;
    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({username: username, privateAcc: privateAcc, name: name, biodata: biodata})
    };
    fetch("/addProfile", options);
    alert("Request to add profile sent successfully.");
}

document.getElementById("deletePost").onclick = () => {
    var deletePostID = document.getElementById("deletePostID").value;
    var deleteProfileID = document.getElementById("deleteProfileID").value;

    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({deletePostID: deletePostID, deleteProfileID: deleteProfileID})
    };
    fetch("/deletepost", options);
    alert("Request to delete post sent successfully.");
}

document.getElementById("likeBtn").onclick = () => {
    var engagement_profile_id = document.getElementById("engagement_profile_id").value;
    var engagement_post_id = document.getElementById("engagement_post_id").value;
    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({engagement_profile_id: engagement_profile_id, engagement_post_id: engagement_post_id, like_dislike: 1})
    };
    fetch("/addEngagement", options);
    alert("Request to add Like sent successfully.");
}

document.getElementById("dislikeBtn").onclick = () => {
    var engagement_profile_id = document.getElementById("engagement_profile_id").value;
    var engagement_post_id = document.getElementById("engagement_post_id").value;
    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({engagement_profile_id: engagement_profile_id, engagement_post_id: engagement_post_id, like_dislike: 0})
    };
    fetch("/addEngagement", options);
    alert("Request to add Dislike sent successfully.");
}

document.getElementById("commentBtn").onclick = () => {
    var engagement_profile_id = document.getElementById("engagement_profile_id").value;
    var engagement_post_id = document.getElementById("engagement_post_id").value;
    var comment = document.getElementById("engagement_comment").value;
    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({engagement_profile_id: engagement_profile_id, engagement_post_id: engagement_post_id, comment: comment})
    };
    fetch("/addEngagement", options);
    alert("Request to add Comment sent successfully.");
}