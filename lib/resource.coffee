cache = require './cache'

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

deleteMiddleware = (model) ->
	return (req, res, next) ->
		return next()

createMiddleware = (model) ->
	return (req, res, next) ->
		obj = new model(req.body)
		obj.save (err) ->
			if err then return res.send(500)
			#res.json(obj)
			res.send(200)

updateMiddleware = (model) ->
	return (res, req, next) ->
		obj = req[model.modelName]
		if not obj? then return res.send(500)
		for key, value of req.body
			obj[key] = value

		obj.save (err) ->
			if err then return next(err)
			res.send(200)

getOneMiddleware = (model) ->
	return (res, req, next) ->
		obj = req[model.modelName]
		if not obj? then return res.send(500)
		res.json obj

getPageMiddleware = (model, obj_count) ->
	return (res, req, next) ->
		getResult = () ->
			if err then return res.send(500)

			model.count({}).exec(err, count) ->
				result = 
					count: count
					data: objects

				res.json result
		sort_opt = {}
		sort_opt[sort_field] = 1

		if obj_count?
			model.find({}).sort(sort_opt).skip((req.page - 1) * obj_count).limit(obj_count).exec (err, objects) ->
				return getResult()
		else
			model.find({}).sort(sort_opt).exec (err, objects) ->	
				return getResult()
		
#Options format
# {read:"all", update: "admin", create: "admin", delete: "admin", cache: true}
add = (app, model) -> 
	console.log "Add model"
	if not model.crudOptions?
		console.log "skip model:" + model.modelName
		return

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
	root = app.config.models.root
	options = model.crudOptions

	console.log options
	if options.create?
		app.post root + model.modelName.toLowerCase(), aclMiddleware(options.create), createMiddleware(model)

	if options.update?
		app.put root + model.modelName.toLowerCase() + "/:" + model_id_name, aclMiddleware(options.update), updateMiddleware(model)

	if options.delete?
		app.delete root + model.modelName.toLowerCase() + "/:" + model_id_name, aclMiddleware(options.delete), deleteMiddleware(model)

	if options.read?
		app.get root + model.modelName.toLowerCase() + "/:" + model_id_name, aclMiddleware(options.read), getOneMiddleware(model)
		app.get root + model.modelName.toLowerCase() + "s/:page", aclMiddleware(options.read), getPageMiddleware(model, app.config.models.onpage)

module.exports.load = (app) ->
	console.log "Load models"
	for file, model of app.models
		console.log model
		console.log "Add model-" + file + "," + model.modelName
		console.log model.crudOptions
		add(app, model)
	console.log "Routes"
	console.log app.routes

