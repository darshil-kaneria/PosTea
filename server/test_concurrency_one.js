/**
 * This file contains a test function that simply adds number upto what is specified in the query.
 * This file is executed on a seperate process. The process can listen to it's parent process for any messages and reply back with data (in our case, with JSON) as needed.
 * Reminder: Do not exceed more than 255 process on our heroku dyno.
 */

process.on("message", message => {
    var check_val = test_func(message.number);
    process.send({"number": check_val}); // This is returned to the parent process
    process.exit();  // It is very important to exit, or else heroku server will start accumulating orphaned processes.
})

function test_func(number){

    console.log("process id: "+process.pid+", number: "+number); // Check the output on heroku logs
    var countNumber = 0;

    // simple loop that adds upto a certain number
    for(i = 0; i < number; i++){
        countNumber++;
    }
    return countNumber;

}