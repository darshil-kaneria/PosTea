process.on("message", message => {
    var check_val = test_func(message.number);
    process.send({"number": check_val});
    process.exit();
})

function test_func(number){

    console.log("process id: "+process.pid+", number: "+number);
    var randomLol = 0;
    for(i = 0; i < number; i++){
        randomLol++;
    }
    return randomLol;

}