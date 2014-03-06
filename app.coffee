express = require "express"
http = require "http"

app = express()
require("./lib/init")(app)

a = []
console.log a
b = a
a.push "aaa"
console.log b

console.log app.config
console.log app.config.process
console.log app.config.process.port

http.createServer(app).listen app.config.process.port
console.log "Express server listening on port " + app.config.process.port