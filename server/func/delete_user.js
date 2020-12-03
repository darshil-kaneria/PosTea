const db = require('./db_connection.js');

process.on("message", message => {
    db.conn.getConnection(async function(err, connection) {
        if (err) {
            return console.error('error: ' + err.message);
        }
        console.log('Database connection established');
        deleteUser(message.account_username, connection).then(function(answer) {
            connection.release();
            if (answer == "User does not exist") {
                process.send({
                    "Error": "User does not exist"
                });
            } else if (answer == "Error: Unauthorized action, account can only be deleted by the creator.") {
                process.send({
                    "Error": "Delete action by unauthorized user"
                });
            } else if (answer == "Success") {
                process.send({
                    "Success": "User deleted"
                });
            } else {
                process.send(answer);
            }
            process.exit();
        });
    });
});

const deleteUser = async (username, connection) => {
    // Account delete
    var selectQuery = "SELECT * FROM profile WHERE username = ?"
    var deleteQuery = "DELETE FROM profile WHERE profile_id = ?";
    var deleteQuery1 = "DELETE FROM account WHERE username = ?";
    var deleteQuery2 = "DELETE FROM user_follower WHERE profile_id = ? OR follower_id = ?";

    var profile_id = 0;

    /*
    // Profile delete
    var selectQuery = "SELECT * FROM profile WHERE username = ?";
    var deleteQuery2 = "DELETE FROM profile WHERE profile_id = ?";

    // Follower, following delete
    var deleteQuery3 = "DELETE FROM user_follower WHERE profile_id = ? OR follower_id = ?";

    // Post delete
    var selectQuery2 = "SELECT * FROM user_post WHERE profile_id = ?";
    var deleteQuery4 = "DELETE FROM user_post WHERE profile_id = ?";

    // Post and Engagement delete
    var deleteQuery5 = "DELETE FROM engagement WHERE post_id = ? OR profile_id = ?";

    // Comment engagement delete
    var deleteQuery6 = "DELETE FROM comm_engagement WHERE post_id = ?";

    // Topic info delete
    var selectQuery3 = "SELECT * FROM topic_info WHERE topic_creator_id = ?";
    var deleteQuery7 = "DELETE FROM topic_info WHERE topic_creator_id = ?";

    // Topic follower Delete
    var deleteQuery8 = "DELETE FROM topic_follower WHERE topic_id = ? OR follower_id = ?";

    // Topic delete content
    var deleteQuery9 = "DELETE FROM topic_content WHERE topic_id = ? OR post_id = ?";

    // Required ID's
    var post_id = 0;
    var topic_id = 0;
    var profile_id = 0;
    */
   return new Promise(async function(resolve, reject) {
    await connection.query(selectQuery,[username],  async function (err, result) {
        if (err) {
            reject(err.message);
        }
        try {
            if (result.length == 0) {
                resolve("User does not exist");
            } else {
                profile_id = result[0].profile_id;
                await connection.query(deleteQuery, [profile_id], async function(err, result) {
                    if (err) {
                        console.log(err);
                        reject(err.message);
                    } else {
                        await connection.query(deleteQuery1, [username], async function(err, result) {
                            if (err) {
                                console.log(err);
                                reject(err.message);
                            } else {
                                await connection.query(deleteQuery2, [profile_id, profile_id], async function(err, result) {
                                    if (err) {
                                        console.log(err);
                                        reject(err.message);
                                    } else {
                                        resolve("Success");
                                    }
                                });
                            }
                        });
                    }
                }
             );   
            }
        } catch (error) {
            reject(err.message);
        }
    }
    );

})
}
    /*
    return new Promise(async function(resolve, reject) {
        await connection.query(selectQuery, [username], async function(err, result) {
            if (err) {
                reject(err.message);
            }
            try {
                if (result.length == 0) {
                    resolve("User does not exist");
                } else if (result[0].username != username) {
                    resolve("Error: Unauthorized action, account can only be deleted by the creator.")
                } else {
                    profile_id = result[0].profile_id;
                    await connection.query(selectQuery2, [profile_id], async function(err, result) {
                        if (err) {
                            console.log(err);
                            reject(err.message);
                        } else {
                            post_id = result[0].post_id;
                            await connection.query(selectQuery3, [profile_id], async function(err, result) {
                                if (err) {
                                    console.log(err);
                                    reject(err.message);
                                } else {
                                    topic_id = result[0].topic_id;
                                    await connection.query(deleteQuery9, [topic_id, post_id], async function(err, result) {
                                        if (err) {
                                            console.log(err);
                                            reject(err.message);
                                        } else {
                                            await connection.query(deleteQuery8, [topic_id, profile_id], async function(err, result) {
                                                if (err) {
                                                    console.log(err);
                                                    reject(err.message);
                                                } else {
                                                    await connection.query(deleteQuery7, [profile_id], async function(err, result) {
                                                        if (err) {
                                                            console.log(err);
                                                            reject(err.message);
                                                        } else {
                                                            await connection.query(deleteQuery6, [post_id], async function(err, result) {
                                                                if (err) {
                                                                    console.log(err);
                                                                    reject(err.message);
                                                                } else {
                                                                    await connection.query(deleteQuery5, [post_id, profile_id], async function(err, result) {
                                                                        if (err) {
                                                                            console.log(err);
                                                                            reject(err.message);
                                                                        } else {
                                                                            await connection.query(deleteQuery4, [profile_id], async function(err, result) {
                                                                                if (err) {
                                                                                    console.log(err);
                                                                                    reject(err.message);
                                                                                } else {
                                                                                    await connection.query(deleteQuery3, [profile_id, profile_id], async function(err, result) {
                                                                                        if (err) {
                                                                                            console.log(err);
                                                                                            reject(err.message);
                                                                                        } else {
                                                                                            await connection.query(deleteQuery2, [profile_id], async function(err, result) {
                                                                                                if (err) {
                                                                                                    console.log(err);
                                                                                                    reject(err.message);
                                                                                                } else {
                                                                                                    await connection.query(deleteQuery, [username], async function(err, result) {
                                                                                                        if (err) {
                                                                                                            console.log(err);
                                                                                                            reject(err.message);
                                                                                                        } else {
                                                                                                            resolve("Success");
                                                                                                        }
                                                                                                    });
                                                                                                }
                                                                                            });
                                                                                        }
                                                                                    });
                                                                                }
                                                                            });
                                                                        }
                                                                    });
                                                                }
                                                            });
                                                        }
                                                    });
                                                }
                                            });
                                        }
                                    });
                                }
                            });
                        }
                    });
                }
            } catch (error) {
                reject(err.message);
            }
        });

    })*/
