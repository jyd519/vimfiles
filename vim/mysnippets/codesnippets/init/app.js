/*
 *  npm i -D express http-proxy-middleware morgan
 * */
const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");
const morgan = require("morgan");

const app = express();

const API_URL = "http://127.0.0.1:8088";
const PUBLIC_PATH = __dirname + "/front_site";
const PORT = 3000;

app.use(
  morgan("dev", {
    skip: (req) => {
      // skip the frequently polling request
      return req.url.endsWith("/progress/tip/");
    },
  })
);

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
      logLevel: "warn",
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
