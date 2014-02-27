cache = require 'lib/cache'
acl = new require 'acl'
acl = new acl(new acl.memoryBackend());

addModelMiddleware = (model) ->
	return (req, res, next) ->
		req.model = model
		next()

#Options format
# {read:"all", update: "admin", create: "admin", delete: "admin", cache: true}
module.exports.init = (app) ->
	app.acl = acl
module.exports.add = (app, model, options) -> 
	if options.create != null
		if options.create == "all"		
			app.post "/" + model.modelName.toLowerCase(), addModelacl.middleware(), addModelMiddleware, 
		else
			app.post "/" + model.modelName.toLowerCase(), addModelMiddleware
