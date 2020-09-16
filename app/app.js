const express = require('express')
const app = express()
const port = process.env.PORT || 3000;
const timestamp = Date.now();
let date_ob = new Date(timestamp);
let date = ("0" + date_ob.getDate()).slice(-2);
let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
let year = date_ob.getFullYear();
let hours = date_ob.getHours();
let minutes = date_ob.getMinutes();
let seconds = date_ob.getSeconds();
console.log(year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds);

//Define request response in root URL (/)
app.get('/', function (req, res) {
  res.send('Hello World')
})
//Launch listening server on port 3000
// const port = PORT || 3000;
app.listen(port, () => console.log(`Server listening on port ${port}`));