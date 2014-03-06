express = require "express"
path = require "path"
myconfig = require "./config"
require_tree = require "require-tree"

module.exports = (app) ->
	config = myconfig.load("config.json")
	app.config = config
	
	#console.log app.config

	#initialize db
	require('../lib/db')(app.config.db)
	app.models = require_tree("../models")
	console.log process.argv
	if process.argv.length > 1
		if process.argv[1] == "--init"
			usr = new app.models.user_model
			for key, value of app.admin_panel.user
				usr[key] = value

			usr.save (err) ->
				if err 
					console.log err
				process.exit(1)

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

	
	require("./resource").load(app)

	console.log config.static.dir

	app.use express.static "../" + config.static.dir

	app.locals.pretty = config.views.pretty;

	# development only
	app.use express.errorHandler()  if "development" is app.get("env")