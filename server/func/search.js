const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async (err, connection) => {
        if (err) {
            // connection.release();
            return console.error("error: " + err.message);
        }

        refreshTopicTimeline(message.topicID, message.offset, message.time, connection).then((answer) => {
            connection.release();
            console.log("Exiting process: " + process.pid);
            process.exit();
        });
        // process.send({ "result": result });
        // connection.release();
    });
    // process.exit()
});

const search asyc (text) {

    
}