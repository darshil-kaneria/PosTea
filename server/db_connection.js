const mysql = require('mysql');
const password = process.env.DB_ACCESS;

var conn = mysql.createPool({
    host: "postea-business.mysql.database.azure.com", 
    user: "posteabusiness@postea-business", 
    password: password, 
    database: 'postea-db', 
    port: 3306, 
});

module.exports.conn = conn;