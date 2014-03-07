module.exports = (app) ->
	routes = require("./routes.json")

	for route of routes
		