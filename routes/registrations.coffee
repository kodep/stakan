passport = require('passport')
express  = require('express')
mongoose = require('mongoose')
router   = express.Router()

User = mongoose.model('User')

router.route('/registrations').post (req, res, next) ->
  User.register(new User(
    username: req.body.username
  ), req.body.password, (err) ->
    if (err)
      res.status(422)
      .json
        success: false
        errors: [err]
    else
      res.json req.user
  )

module.exports = router
