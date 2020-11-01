const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
          if (err) {
            return console.error('error: ' + err.message);
          }
          console.log('Database connection established');
          await getTrendingPosts(connection).then((answer)=> {
            connection.release();
            process.send(answer);
            process.exit();
          }).catch((err) => {
              connection.release();
              process.send(err);
              process.exit();
          });
          
          
        });
});

const getTrendingPosts = async(connection) => {

    return new Promise(async (resolve, reject) => {

        var redis = db.redis_conn.createClient(process.env.REDISCLOUD_URL, {no_ready_check: true});
        redis.get('posts', (err, data) => {
            dataJson = JSON.parse(data);
            resolve(dataJson);
        });

    });
    
}