passport = require 'passport'

LocalStrategy = require('passport-local').Strategy


passport.use(new LocalStrategy((username, password, done) ->
	console.log "Validate user-" + username
	User = require "../user_model"
	User.findOne { username: username }, (err, user) ->
		console.log "Try to find:" + username
		return done err if err
		console.log "-"
		console.log user
		console.log password
		return done null, false, { message: 'Incorrect username.' } if !user
		console.log "--"
		user.comparePassword password, (err, isMatch) ->
			return done err if err
			return done null, user if isMatch
			return done null, false, message: 'Invalid password'))

passport.serializeUser (user, done) -> 
	console.log user
	done null, user.id

passport.deserializeUser (id, done) -> User.findById id, (err, user) -> done(err, user)

module.exports.aclMiddleware = (userType) ->
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

module.exports.use = (app) ->
	app.use(passport.initialize());
	app.use(passport.session());

	
