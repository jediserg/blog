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
createMiddleware = (model)
	return (req, res, next) ->
		req.model = model
		

#Options format
# {read:"all", update: "admin", create: "admin", delete: "admin", cache: true}
add = (app, model, options) -> 
	if options.create?
		switch options.create
			when "all" then 
		if options.create == "all" app.post "/" + model.modelName.toLowerCase(), addModelMiddleware(model)
			, 
		else
			app.post "/" + model.modelName.toLowerCase(), addModelMiddleware()

module.exports.load = (app)
	for app.models in model
		add(app, model) if model.crudOption

