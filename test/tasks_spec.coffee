h         = require './test_helper'
mongoose  = require('mongoose')

Task = mongoose.model('Task')

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

  describe 'GET /tasks/:id', ->
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

  describe 'POST /tasks', (done) ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb =>
        h.registerUser(userEmail, userPass)
        .then (user) =>
          @user = user
          token = user.token
        .then =>
          h.registerUser('second@mail.ru', 'second_user')
          .then (user) =>
            @second_user = user
            done()

    it 'allows registered user to create task', (done) ->
      h.agent.post('/api/tasks/')
      .set('Authorization', "Token #{token}")
      .send
        content: 'blablabla'
        user_id:  @second_user._id
      .then (res, err) =>
        return done(err) if err
        tasks = Task.find
          user: @second_user._id
        .then (tasks) ->
          tasks.length.should.equal 1
          done()

  taskCreated = undefined

  describe 'DELETE /tasks/:id', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb =>
        h.registerUser(userEmail, userPass)
        .then (user) =>
          token = user.token
          @user = user
          h.createTaskForUser(user, 'Blablabla')
        .then (task) ->
          taskCreated = task
        .then ->
          h.registerUser('second@mail.ru', 'second_user')
        .then (user) =>
          @second_user = user
          done()

    it 'allows registered user to delete his own task', (done) ->
      h.agent.delete("/api/tasks/#{taskCreated._id}")
      .set('Authorization', "Token #{token}")
      .then (res, err) =>
        return done(err) if err
        tasks = Task.find
          user: @user._id
        .then (tasks) ->
          tasks.length.should.equal 0
          done()

    it 'does not allow to delete user not involved in', (done) ->
      h.agent.delete("/api/tasks/#{taskCreated._id}")
      .set('Authorization', "Token #{@second_user.token}")
      .expect 401
      .then (res, err) =>
        return done(err) if err
        tasks = Task.find
          user: @user._id
        .then (tasks) ->
          tasks.length.should.equal 1
          done()
