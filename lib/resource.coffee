cache = require 'lib/cache'

aclMiddleware = (userType) ->
	return (req, res, next) ->
		if userType == "all" then return next()

		if !req.isAuthenticated()
			return res.redirect("/")
		if typeof myVar == 'string' || myVar instanceof String
			if req.user.userType == userType then return next()
		else
			for type in userType
				if type == req.user.userType 
					return next()

		return res.redirect("/login")

createMiddleware = (model) ->
	return (req, res, next) ->
		obj = new model(req.body)
		obj.save (err) ->
			if err then return res.send(500)
			#res.json(obj)
			res.send(200)

updateMiddleware = (model)

		
#Options format
# {read:"all", update: "admin", create: "admin", delete: "admin", cache: true}
add = (app, model) -> 
	if not model.crudOption? then return

	model_id_name =  modelName.toLowerCase() + "Id"
	app.param model_id_name, (req, res, next, id) ->
		model

	options = model.crudOption
	if options.create?
		app.post "/" + model.modelName.toLowerCase(), aclMiddleware(options.create), createMiddleware(model)

	if options.update?
		app.put "/" + model.modelName.toLowerCase() + "/:" + model_id_name, aclMiddleware(options.update), updateMiddleware(model)

	if options.delete?
		app.delete "/" + model.modelName.toLowerCase() + "/:" + model_id_name, aclMiddleware(options.delete), readMiddleware(model)	



module.exports.load = (app) ->
	for app.models in model
		add(app, model) if model.crudOption?

