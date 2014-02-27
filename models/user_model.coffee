#User Schema
bcrypt = require 'bcrypt'
SALT_WORK_FACTOR = 10
mongoose = require "mongoose"

UserSchema = mongoose.Schema
	username:
		type: String, required: true, unique: true
	email:
		type: String, required: true, unique: true
	password:
		type: String, required: true
	role:
		type: String, required: true

#Bcrypt middleware
UserSchema.pre 'save', (next) ->
	user = @

	return next() if !@isModified 'password'

	bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
				return next err if err
				console.log "Salt-" + salt + ", pass-" + user.password
				bcrypt.hash user.password, salt, (err, hash) ->
					next(err) if err
					user.password = hash;
					next();

#Password verification
UserSchema.methods.comparePassword = (candidatePassword, cb)->
		bcrypt.compare candidatePassword, @password, (err, isMatch) ->
			return cb err if err
			cb null, isMatch

#UserSchema.statics.routeOptions = create :read : ["self", "admin"]

# Seed a user
module.exports = mongoose.model('User', UserSchema);