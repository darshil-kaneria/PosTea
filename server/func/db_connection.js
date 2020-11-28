/**
 * This file contains all database configurations and needs to be imported into every file that intends
 * to communicate with the database. This file is not imported in main.js
 * For testing the server locally, hardcode the password to the password variable. For example, see the PORT variable in main.js
 */

 /*****************
  * DO          ***
  * NOT         ***
  * ADD         ***
  * THE         ***
  * HARDCODED   ***
  * PASSWORD    ***
  * HERE        ***
  * PLEASE      ***
  *****************/
const mysql = require('mysql');

/**
 * I WILL CHANGE THE DATABASE PASSWORD IF I SEE THE HARDCODED PASSWORD HERE
 */
                                                                                                                                                                                                                                                                                                                                                                                                                   const password = process.env.DB_ACCESS; // DO NOT ADD THE HARDCODED PASSWORD HERE OR I WILL CHANGE THE PASSWORD
/**
 * I WILL CHANGE THE DATABASE PASSWORD IF I SEE THE HARDCODED PASSWORD HERE
 */
/*****************
  * DO          ***
  * NOT         ***
  * ADD         ***
  * THE         ***
  * HARDCODED   ***
  * PASSWORD    ***
  * HERE        ***
  * PLEASE      ***
  *****************/
var conn = mysql.createPool({
    host: "postea-business.mysql.database.azure.com", 
    user: "posteabusiness@postea-business", 
    password: password, 
    database: 'postea-db', 
    port: 3306, 
    connectionLimit: 20
});

// Redis cache connection
var redis_conn = require('redis');

module.exports.conn = conn;
module.exports.redis_conn = redis_conn;