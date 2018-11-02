// express
const express = require('express');
const http = require('http');
const url = require('url');

const app = express();

app.use(function (req, res) {
  console.log(req.path, req.querystring);
  if (req.path === '/updates/latest') {
    res.send(updateInfo);
  } else {
    res.sendfile('.' + req.path);
  }
});

const server = http.createServer(app);
server.listen(8080, function listening() {
  console.log('Listening on %d', server.address().port);
});

