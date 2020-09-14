const express = require('express');
const app = express();
const PORT = process.env.PORT || 23556
const fork = require("child_process").fork;
app.get('/', (req, res)=>{
    const child = fork('./test_concurrency_one.js');
    child.send({"number": parseInt(req.query.number)});
    child.on("message", message => res.send(message));
});

app.listen(PORT, ()=>console.log("listening on port "+PORT));