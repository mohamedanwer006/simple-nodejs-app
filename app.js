const express = require('express');
const app = express();
const port = process.env.PORT || 3000;


app.get('/',function(req,res){
    res.send("<h1> Hello World  🌍 , ITI graduation project </h1> <br> <h2> By  : Mohamed Anwar 💻 </h2>");
  });


app.listen(port, () => {
    console.log(`Running at  http://localhost:${port}`)
})