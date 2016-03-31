h = require './test_helper'

userEmail = 'user@example.com'
userPass  = 'supersecret'

describe 'Me', ->

  describe '/me', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb ->
        h.registerUser(userEmail, userPass).then ->
          done()

    it 'gives current user when signed in', (done) ->
      h.login(userEmail, userPass)
      .expect(200)
      .then (err, res) ->
        h.agent.get('/api/me/')
        .expect 200
        .then (res) ->
          res.body.username.should.equal userEmail
          done()
