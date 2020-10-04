document.getElementById("btn1").onclick = () => {
    var post = document.getElementById("text").value;
    var topic = document.getElementById("topicText").value;
    var postID = document.getElementById("postID").value;
    var profileID = document.getElementById("profileID").value;
    var topicID = document.getElementById("topicID").value;
    var likes = document.getElementById("likes").value;
    var dislikes = document.getElementById("dislikes").value;
    var comment = document.getElementById("postComments").value;
    options = {
        method: "POST",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ msg: post, topic: topic, postID: postID, profileID: profileID, topicID: topicID, likes: likes, dislikes: dislikes, comment: comment})
    };
    fetch("/makePost", options);
}

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
}