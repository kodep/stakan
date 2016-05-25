passport  = require('passport')
express  = require('express')
mongoose = require('mongoose')
router   = express.Router()

Task = mongoose.model('Task')
User = mongoose.model('User')

router.get(
  '/tasks',
  passport.authenticate('http-header-token'),
  (req, res, next) ->
    if req.user?
      tasks = Task.find
        user: req.user._id
      .then (tasks) ->
        res.json
          tasks: tasks
    else
      res.status 404
      next()
)

router.get(
  '/tasks/:user_id',
  passport.authenticate('http-header-token'),
  (req, res, next) ->
    User.findById req.params.user_id
    .then (user) ->
      tasks = Task.find
        user: user._id
    .then (tasks) ->
      res.json
        tasks: tasks
)

module.exports = router
