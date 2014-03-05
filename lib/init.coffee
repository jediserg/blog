path = require "path"
config = require "nconf"
require_tree = require('require-tree')

module.exports = (app) ->
	app.config = config
	app.config.argv().file({file : "../config.json"})

	console.log app.config

	#initialize db
	require('../lib/db')()
		
	# all environments
	app.set "port", config.get("process.port")

	app.set "views", __dirname + config.get("views.dir")
	app.set "view engine", config.get("views.engine")

	app.use express.favicon()
	app.use express.logger("dev")
	app.use express.cookieParser()
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.session secret: config.get("session.secret")

	require('./lib/auth')(app)

	app.models = require_tree("../models")

	app.use express.static(path.join(__dirname, config.get("static.dir")

	app.locals.pretty = config.views.pretty;

	# development only
	app.use express.errorHandler()  if "development" is app.get("env")