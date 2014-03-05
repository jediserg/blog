express = require "express"
http = require "http"

app = express()
require("./lib/init")(app)
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")