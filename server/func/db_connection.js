/**
 * This file contains all database configurations and needs to be imported into every file that intends
 * to communicate with the database. This file is not imported in main.js
 * For testing the server locally, hardcode the password to the password variable. For example, see the PORT variable in main.js
 */

const mysql = require('mysql');
<<<<<<< HEAD
const password = process.env.DB_ACCESS  || "e3TxsUd6da66m2D";; // DO NOT FORGET to remove the hardcoded password (if used) before pushing to Github or Heroku.
=======
const password = process.env.DB_ACCESS || "e3TxsUd6da66m2D"; // DO NOT FORGET to remove the hardcoded password (if used) before pushing to Github or Heroku.
>>>>>>> 3fcda29f6aee7d476dfe521833efb8c293fc2615

var conn = mysql.createPool({
    host: "postea-business.mysql.database.azure.com", 
    user: "posteabusiness@postea-business", 
    password: password, 
    database: 'postea-db', 
    port: 3306, 
});

module.exports.conn = conn;
