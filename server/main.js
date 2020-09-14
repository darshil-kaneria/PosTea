const express = require('express');
const app = express();
const PORT = process.env.PORT || 23556
app.get('/', (req, res)=>{
    res.send('<p> TEST <p>');
});

app.listen(PORT, ()=>console.log("listening on port "+PORT));