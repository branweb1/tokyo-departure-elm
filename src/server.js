const express = require('express')
const path = require('path')

const app = express()

// app.use(express.static(path.resolve(__dirname + '/../dist')));
app.get('*', function(req, res) {
  res.sendFile(path.join(__dirname, 'index.html'))
})

module.exports = app
