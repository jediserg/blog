###
Module dependencies.
###

articles = require __dirname + "/out.js"
out_articles = []
out_blog = []


#console.log "A:" + out_articles.size() + ", " + out_blog.size()
#console.log articles
console.log "------------------"
#
express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")
app = express()
router = require './router'
mongoose = require "mongoose"
mongoose.connect 'mongodb://localhost/blog'
db = mongoose.connection
User = require "./models/user_model"
Article = require "./models/article_model"
db.on 'error', console.error.bind(console, 'connection error:')
###
for a in articles
		console.log a.catid
		if a.catid == 80 || a.catid == 81
			out_articles.push a
			console.log a

str = JSON.stringify out_articles
fs = require 'fs'
fs.writeFileSync('out.js', str)
process.exit(0)
###
db.once 'open', ()-> 
	console.log 'Connected to DB'
	console.log "-----------------------------"
	console.log "size" + articles.length
###	
	for a in articles
			console.log "-"
			art = new Article(title: a.title, url: a.alias, content: a.fulltext, preview: a.introtext)
			art.save (err) ->
				if err
					console.log err
				else
					console.log "Added:" + art.id
###					
#process.exit(0)		
###
	
	User.findOne {username: 'admin'}, (err, user) -> 
		console.log err if err
		user.remove()
		console.log "Admin removed"
	
###

###
	User = require "./models/user_model"

	user = new User({ username: 'admin', email: 'jedi.serg@gmail.com', password: 'qpalzm123' });
	user.save (err)->
		if(err)
			console.log err
		else
			console.log user
			console.log 'user: ' + user.username + " saved."
###
#passport
passport = require 'passport'

LocalStrategy = require('passport-local').Strategy

auth = require "./auth"
console.log auth
passport.use(new LocalStrategy(auth))

passport.serializeUser (user, done) -> 
	console.log user
	done null, user.id



passport.deserializeUser (id, done) -> User.findById id, (err, user) -> done(err, user)

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
console.log require(__dirname + "/config/config").menu.items.length
app.locals.config = require(__dirname + "/config/config")

app.use express.favicon()
app.use express.logger("dev")
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session secret: 'keyboard cat'

app.use(passport.initialize());
app.use(passport.session());

app.use app.router
app.use require("stylus").middleware(path.join(__dirname, "public"))
app.use express.static(path.join(__dirname, "public"))

app.locals.pretty = true;

router.init1 app
console.log(app.routes)
# development only
app.use express.errorHandler()  if "development" is app.get("env")
#app.get "/", routes.index
#app.get "/users", user.list
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

