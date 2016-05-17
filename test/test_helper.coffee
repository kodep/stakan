config   = require('../config/test')
mongoose = require('mongoose')
Promise  = require('promise')
request  = require('supertest')
require('promise/lib/rejection-tracking').enable()
require('should-http')

dbUri = config.db.mongodb

app  = require('../app')

User = mongoose.model('User')
Task = mongoose.model('Task')

connectMongoose = ->
  mongoose.connect(dbUri) unless mongoose.connection.readyState

registerUser = (username, password) ->
  new Promise (resolve, reject) ->
    user = new User
      username: username
    User.register user, password, (err) ->
      if err
        reject(err)
      else
        resolve(user)

agent = request.agent(app)

login = (username, password) ->
  agent.post('/api/sessions/')
  .send
    username: username
    password: password

register = (username, password) ->
  agent.post('/api/registrations/')
  .send
    username: username
    password: password

createTaskForUser = (user, content) ->
  task = new Task
    content: content
    user: user._id
  task.save()

module.exports =
  should:   require('should')
  assert:   require('assert')
  config:   require('../config/test')
  mongoose: require('mongoose')
  user:     require('../models/user')
  dbUri:    dbUri
  clearDb:  require('mocha-mongoose')(config.db.mongodb)
  request:  require('supertest')
  app:      app
  User:     User
  connectMongoose:   connectMongoose
  registerUser:      registerUser
  agent:             agent
  login:             login
  register:          register
  createTaskForUser: createTaskForUser
