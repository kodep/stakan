h = require './test_helper'

userEmail = 'user@example.com'
userPass  = 'supersecret'
token     = undefined

describe 'Tasks API', ->

  describe '/tasks', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb ->
        h.registerUser(userEmail, userPass)
        .then (user) ->
          token = user.token
          h.createTaskForUser(user, 'Blablabla')
        .then ->
          done()

    it 'gives list of mine tasks', (done) ->
      h.login(userEmail, userPass, token)
      .expect(200)
      .then (err, res) ->
        h.agent.get('/api/tasks')
        .set('Authorization', "Token #{token}")
        .expect 200
        .then (res, err) ->
          res.body.tasks.length.should.equal 1
          done()

    it 'returns 400 when user is not logged in', (done) ->
      h.request(h.app).get('/api/tasks')
      .expect 400, done

  describe '/tasks/:id', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb =>
        h.registerUser(userEmail, userPass)
        .then (user) =>
          token = user.token
          @user = user
          h.createTaskForUser(user, 'Blablabla')
        .then ->
          done()

    it 'gives list of user tasks', (done) ->
      h.agent.get('/api/tasks/' + @user._id)
      .set('Authorization', "Token #{token}")
      .expect 200
      .then (res, err) ->
        res.body.tasks.length.should.equal 1
        done()
