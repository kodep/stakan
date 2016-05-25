h = require './test_helper'

userEmail = 'user@example.com'
userPass  = 'supersecret'
token     = undefined

describe 'Me', ->
  describe '/me', ->
    beforeEach (done) ->
      h.connectMongoose()
      h.clearDb ->
        h.registerUser(userEmail, userPass).then (user) ->
          token = user.token
          done()

    it 'gives current user when signed in', (done) ->
      h.login(userEmail, userPass, token)
      .expect 200
      .then (res, err) ->
        return done(err) if err
        h.agent.get('/api/me/')
        .set('Authorization', "Token #{token}")
        .expect 200
        .then (res, err) ->
          return done(err) if err
          res.body.username.should.equal userEmail
          done()

    it 'gives 400 when token is not specified', (done) ->
      h.agent.get('/api/me/')
      .expect 400
      .end done

    it 'gives 401 when token is wrong', (done) ->
      h.agent.get('/api/me/')
      .set('Authorization', "Token aaa")
      .expect 401
      .end done
