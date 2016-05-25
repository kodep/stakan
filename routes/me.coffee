passport  = require('passport')
express   = require('express')
mongoose  = require('mongoose')
router    = express.Router()

router.get '/me', passport.authenticate('http-header-token'), (req, res) ->
  res.json req.user

module.exports = router
