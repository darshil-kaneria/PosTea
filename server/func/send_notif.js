const db = require('./db_connection.js');
var fcmAdmin = require('firebase-admin');

fcmAdmin.initializeApp({
    credential: fcmAdmin.credential.applicationDefault(),
    databaseURL: "https://postea-eabea.firebaseio.com"
});
process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
        if(err){
            return console.error("Error addToken: "+err);
        }

        await getToken(message, connection).then((value) => {
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

const getToken = async function(message, connection) {
    return new Promise(function(resolve, reject){
        // Add the latest device token for an account. Replace the original one.
        var query = `select token from profile where profile_id=${message.profileID}`;
        connection.query(query, function(err, result){
            if(err){
                reject(err);
            }
            
            var deviceToken = JSON.stringify(result);
            var deviceTokenJSON = JSON.parse(deviceToken);
            console.log(deviceTokenJSON[0]['token']);
            var data = {
                notification: {
                    title: message.title,
                    body: message.body
                },
            }
            fcmAdmin.messaging().sendToDevice(deviceTokenJSON[0]['token'], data).then((result) => {
                console.log(result);
                resolve(result);
            });
            
        })
    });
}