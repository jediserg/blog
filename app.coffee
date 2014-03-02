express = require "express"
http = require "http"
path = require "path"
app = express()
config = require "nconf"

app.config = config
app.config.argv().file({file : "config.json"})

require('./lib/db')()
	
# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"

app.use express.favicon()
app.use express.logger("dev")
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session secret: 'keyboard cat'

require('./lib/auth')(app)

app.use express.static(path.join(__dirname, "public"))

app.locals.pretty = true;

# development only
app.use express.errorHandler()  if "development" is app.get("env")
#app.get "/", routes.index
#app.get "/users", user.list
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

