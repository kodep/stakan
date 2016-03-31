express       = require 'express'
path          = require 'path'
favicon       = require 'serve-favicon'
logger        = require 'morgan'
cookieParser  = require 'cookie-parser'
bodyParser    = require 'body-parser'
mongoose      = require 'mongoose'
passport      = require 'passport'
LocalStrategy = require('passport-local').Strategy
session       = require 'express-session'

User          = require('./models/user')
Task          = require('./models/task')

routesSessions      = require './routes/sessions'
routesRegistrations = require './routes/registrations'
routesMe            = require './routes/me'
routesTasks         = require './routes/tasks'

require('coffee-script/register')

app = express()

app.use session
  secret:            'topsecret'
  resave:            false
  saveUninitialized: false

app.use passport.initialize()
app.use passport.session()

# Configure passport-local to use account model for authentication
passport.use new LocalStrategy(User.authenticate())

passport.serializeUser User.serializeUser()
passport.deserializeUser User.deserializeUser()

# view engine setup
app.set 'views', path.join __dirname, 'build'
app.set 'view engine', 'jade'

# uncomment after placing your favicon in /public
# app.use favicon "#{__dirname}/public/favicon.ico"
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded
  extended: false
app.use cookieParser()
app.use express.static path.join __dirname, 'public'
app.use express.static path.join __dirname, 'build'

app.use '/api', routesSessions
app.use '/api', routesRegistrations
app.use '/api', routesMe
app.use '/api', routesTasks

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
        console.log 'ERROR:', err
        console.error err.stack
        res.status err.status or 500
        res.render 'error',
            message: err.message,
            error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status or 500
    console.log 'ERROR:', err
    res.render 'error',
        message: err.message,
        error: {}

module.exports = app
