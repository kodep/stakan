express  = require('express')
mongoose = require('mongoose')
router   = express.Router()

router.route('/me').get (req, res) ->
  res.json req.user

module.exports = router
