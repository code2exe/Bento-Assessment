const express = require('express')
require('dotenv').config()
const app = express()
const port = process.env.PORT || 3000;
let time = new Date()
let year = time.getFullYear()
let month = time.getMonth()
let date = time.getDate()
let hours = time.getHours()
let minutes = time.getMinutes()
let seconds = time.getSeconds()
let timestamp = `${year}-${month}-${date} ${hours}:${minutes}:${seconds}`;

//Define request response in root URL (/)
app.get('/', function (req, res) {
  res.send(timestamp)
})
app.listen(port, () => console.log(`Server listening on port ${port}`));