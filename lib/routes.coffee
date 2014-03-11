routes = require("./routes.json")

module.exports = (app) ->
	for route of routes
		app.get route.url, (app, route) ->
			models = route.models.map (model_name) -> app.models[model_name]

			res.render route.view, 
				models: models
				config: app.config
				title:  route.title