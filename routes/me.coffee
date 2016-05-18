passport  = require('passport')
express   = require('express')
mongoose  = require('mongoose')
router    = express.Router()

router.get '/me',
  passport.authenticate( 'http-header-token',
    session: false
  ), (req, res) ->
    res.json req.user

module.exports = router
