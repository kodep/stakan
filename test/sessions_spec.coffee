h = require './test_helper'

userEmail = 'user@example.com'
userPass  = 'supersecret'

describe 'Sessions', ->
  describe 'sign in', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb ->
        h.registerUser(userEmail, userPass).then ->
          done()

    it 'is successful on correct combination of login and password', (done) ->
      h.login(userEmail, userPass)
      .expect(200)
      .then (err, res) ->
        done()

    it 'is fails on incorrect combination of login and password', (done) ->
      h.login(userEmail, 'wrongpass')
      .expect(401)
      .then (err, res) ->
        done()

    it 'is unsuccessful on unexistent login and password', (done) ->
      h.login('nonexist@example.com', 'wrongpass')
      .expect(401)
      .then (err, res) ->
        done()

  describe 'sign up', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb done

    it 'is creates new user if everything is ok', (done) ->
      h.register('user2@example.com', 'supersecret2')
      .expect(200)
      .then ->
        done()

    it 'validates username uniqueness', (done) ->
      h.registerUser(userEmail, userPass)
      .then -> h.register(userEmail, userPass).expect(422)
      .then (err, res) ->
        done()
