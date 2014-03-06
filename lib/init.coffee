express = require "express"
path = require "path"
myconfig = require "./config"
require_tree = require "require-tree"

module.exports = (app) ->
	config = myconfig.load("config.json")
	app.config = config
	
	#console.log app.config

	#initialize db
	require('../lib/db')()

	# all environments
	#console.log config.process
	app.set "port", config.process.port
	app.set "views", __dirname + config.views.dir
	app.set "view engine", config.views.engine

	app.use express.favicon()
	app.use express.logger("dev")
	app.use express.cookieParser()
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.session secret: config.session.secret

	require('../lib/auth')(app)

	app.models = require_tree("../models")
	require("./resource").load(app)

	console.log config.static.dir

	app.use express.static "../" + config.static.dir

	app.locals.pretty = config.views.pretty;

	# development only
	app.use express.errorHandler()  if "development" is app.get("env")