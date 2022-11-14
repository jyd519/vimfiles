/*
  * eslint-disable
 *  npm i -D express http-proxy-middleware
 * */
const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");

const app = express();

const API_URL = "http://127.0.0.1:8088";
const PUBLIC_PATH = __dirname + "/dist/joycloud";
const PORT = 3000;

const API_PREFIXES = [
  { prefix: "/dapi", target: API_URL },
  { prefix: "/api", target: API_URL },
  { prefix: "/ts-api", target: API_URL },
  { prefix: "/ws", target: API_URL, ws: true },
];

API_PREFIXES.forEach((c) => {
  app.use(
    c.prefix,
    createProxyMiddleware({
      target: c.target,
      changeOrigin: true,
      ws: !!c.ws,
    })
  );
});

app.use(express.static(PUBLIC_PATH));

app.get("*", function (req, res) {
  console.log("request:", req.url);
  res.sendFile(PUBLIC_PATH + "/index.html");
});

app.listen(PORT, () => {
  console.log("listening on port ", PORT);
});