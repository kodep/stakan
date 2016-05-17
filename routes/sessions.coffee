passport = require('passport')
express  = require('express')
mongoose = require('mongoose')
router   = express.Router()

User = mongoose.model('User')
router.route('/sessions').post passport.authenticate('local'), (req, res) ->
  res.json req.user

module.exports = router
