passport  = require('passport')
express   = require('express')
mongoose  = require('mongoose')
randtoken = require('rand-token')
router    = express.Router()

User = mongoose.model('User')

router.post '/registrations', (req, res) ->
  user = new User
    username: req.body.username
    token: randtoken.uid(16)

  User.register(user, req.body.password, (err) ->
    if (err)
      res.status(422)
      .json
        success: false
        errors: [err]
    else
      res.json user
  )

module.exports = router
