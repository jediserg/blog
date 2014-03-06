fs = require 'fs'
module.exports.load = (name) ->
	return JSON.parse fs.readFileSync(name)
