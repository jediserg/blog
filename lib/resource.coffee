cache = require './cache'
auth = require './auth'


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
	return (req, res, next) ->
		getResult = (objects) ->
			model.count({}).exec (err, count) ->
				result = 
					count: count
					data: objects
				console.log res
				res.json result
		sort_opt = {}
		sort_field = "_id"
		if model.sortField? then sort_field = model.sortField

		sort_opt[sort_field] = 1

		if obj_count?
			model.find({}).sort(sort_opt).skip((req.page - 1) * obj_count).limit(obj_count).exec (err, objects) ->
				if err then return res.send(500)
				return getResult(objects)
		else
			model.find({}).sort(sort_opt).exec (err, objects) ->	
				if err then return res.send(500)
				return getResult(objects)
		
#Options format
# {read:"all", update: "admin", create: "admin", delete: "admin", cache: true}
add = (app, model) -> 
	if not model.crudOptions?
		console.log "skip model:" + model.modelName
		return

	model_id_name = model.modelName.toLowerCase() + "Id"
	
	root = app.config.models.root
	options = model.crudOptions

	if options.create?
		app.post root + model.modelName.toLowerCase(), auth.aclMiddleware(options.create), createMiddleware(model)

	if options.update?
		app.put root + model.modelName.toLowerCase() + "/:" + model_id_name, auth.aclMiddleware(options.update), updateMiddleware(model)

	if options.delete?
		app.delete root + model.modelName.toLowerCase() + "/:" + model_id_name, auth.aclMiddleware(options.delete), deleteMiddleware(model)

	if options.read?
		app.get root + model.modelName.toLowerCase() + "/:" + model_id_name, auth.aclMiddleware(options.read), getOneMiddleware(model)
		app.get root + model.modelName.toLowerCase() + "s/:page", auth.aclMiddleware(options.read), getPageMiddleware(model, app.config.models.onpage)

module.exports.load = (app) ->
	console.log "Load models"
	for file, model of app.models
		add(app, model)