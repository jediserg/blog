routes = require("./routes.json")
async = require
getTitle = (app, req, route) ->
	if route.title?
		route.title
	else
		if route.models?
			if route.model.length is 1
				model = req[route.model[0].name]
				if model? then throw "Couldn't find model:" + route.model[0].name
				model.getTitle()
			else
				if route.model.length > 0
					for model in route.models
						if model.useTitle? and model.getTitle?
							return model.getTitle()

loadModels = (req, route, cb) ->
	models = []

	async.eachSeries req.__route
	for model_info in route.models
		if model_info.action == "get"

	models

module.exports = (app) ->
	for model in app.models
		model_id_name = model.modelName.toLowerCase() + "Id"

		app.param model_id_name, (req, res, next, id) ->
			idField = model.idField
			if not idField? then idField = "_id"
			filter = {}
			filter[idField] = id

			model.findOne filter, (err, obj) ->
				if err then return next(err)
				req[model.modelName] = obj
				return next()

		app.param "page", (req, res, next, id) ->
			req.page = id
			next()

	for route of routes

		app.get url, (req, res, next) ->
			options = {}

			async.mapSeries route.models, 
				(model, callback) ->
					if action == "get"
						return req.get
					if action == "list"
						model.getPage req.page, callback
				,
				(err, result) ->
					options = {}
					options.title = route.title ? getTitle(result)
					res.render route.view, 
						title: route.title ? getTitle(result)
						page: req.page
						models: 


			loadModels req, (result) ->
				for models
				res.render route.view, 
					models: models
					config: app.config
					title:  getTitle(req, route)