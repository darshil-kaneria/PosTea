/**
 * This file contains all database configurations and needs to be imported into every file that intends
 * to communicate with the database. This file is not imported in main.js
 * For testing the server locally, hardcode the password to the password variable. For example, see the PORT variable in main.js
 */
const mysql = require('mysql');
const password = process.env.DB_ACCESS;
var conn = mysql.createPool({
    host: "postea.mysql.database.azure.com", 
    user: "posteabusiness@postea", 
    password: password, 
    database: 'postea', 
    port: 3306, 
    connectionLimit: 20
});

// Redis cache connection
var redis_conn = require('redis');

module.exports.conn = conn;
module.exports.redis_conn = redis_conn;