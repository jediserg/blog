module.exports = () ->	
	mongoose = require "mongoose"
	mongoose.connect 'mongodb://localhost/new_blog'
	db = mongoose.connection

	db.on 'error', console.error.bind(console, 'connection error:')

	db.once 'open', ()-> 
		console.log 'Connected to DB'
