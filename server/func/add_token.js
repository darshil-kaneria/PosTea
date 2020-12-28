const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
        if(err){
            return console.error("Error addToken: "+err);
        }

        await addToken(message, connection).then((value) => {
            connection.release();
            process.send(value);
            process.exit();
        }).catch((err) => {
            connection.release();
            process.send(err);
            process.exit();
        });
    });
});

const addToken = async function(message, connection) {
    return new Promise(function(resolve, reject){
        // Add the latest device token for an account. Replace the original one.
        var query = `update profile set token = "${message.token}" where profile_id=${message.profileID}`
        connection.query(query, function(err, result){
            if(err){
                reject(err);
            }
            resolve(result)
        })
    });
}