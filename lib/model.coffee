module.exports.getPage(page, sort_field, cb) ->
	getResult = (objects, cb) ->
		model.count({}).exec (err, count) ->
			result = 
				count: count
				data: objects
			console.log res
			cb err, result

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