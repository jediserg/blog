cache = require 'lib/cache'

aclMiddleware = (userType) ->
	return (req, res, next) ->
		if userType == "all" then return next()

		if !req.isAuthenticated()
			res.redirect("/")
		return



addModelMiddleware = (model) ->
	return (req, res, next) ->
		req.model = model
		next()
createMiddleware = (req, res, next) ->

#Options format
# {read:"all", update: "admin", create: "admin", delete: "admin", cache: true}
module.exports.init = (app) ->
	app.acl = acl
module.exports.add = (app, model, options) -> 
	if options.create != null
		if options.create == "all"		
			app.post "/" + model.modelName.toLowerCase(), addModelMiddleware(model), 
		else
			app.post "/" + model.modelName.toLowerCase(), addModelMiddleware()
