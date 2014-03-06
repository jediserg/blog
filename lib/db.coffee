module.exports = (config) ->	
	mongoose = require "mongoose"
	mongoose.connect config.url
	db = mongoose.connection

	db.on 'error', console.error.bind(console, 'connection error:')

	db.once 'open', ()-> 
		console.log 'Connected to DB'
