routes = require("./routes.json")

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
						if model.useTitle? and model.getTitle()
							return model.getTitle()

loadModels = (req, cb) ->
	models = []

	for model_info in route.models
		if model_info
	models

module.exports = (app) ->
	for route of routes

		app.get url, (req, res, next) ->
			options = {}

			req.__route = route

			loadModels req, (result) ->
				for models
				res.render route.view, 
					models: models
					config: app.config
					title:  getTitle(req, route)