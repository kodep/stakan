h = require './test_helper'

userEmail = 'user@example.com'
userPass  = 'supersecret'

describe 'Tasks API', ->

  describe '/tasks', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb ->
        h.registerUser(userEmail, userPass)
        .then (user) ->
          h.createTaskForUser(user, 'Blablabla')
        .then ->
          done()

    it 'gives list of mine tasks', (done) ->
      h.login(userEmail, userPass)
      .expect(200)
      .then (err, res) ->
        h.agent.get('/api/tasks')
        .expect 200
        .then (res, err) ->
          res.body.tasks.length.should.equal 1
          done()

    it 'returns 404 when user is not logged in', (done) ->
      h.request(h.app).get('/api/tasks')
      .expect 404, done

  describe '/tasks/:id', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb =>
        h.registerUser(userEmail, userPass)
        .then (user) =>
          @user = user
          h.createTaskForUser(user, 'Blablabla')
        .then ->
          done()

    it 'gives list of user tasks', (done) ->
      h.agent.get('/api/tasks/' + @user._id)
      .expect 200
      .then (res, err) ->
        res.body.tasks.length.should.equal 1
        done()
