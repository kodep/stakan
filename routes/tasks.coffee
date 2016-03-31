express  = require('express')
mongoose = require('mongoose')
router   = express.Router()

Task = mongoose.model('Task')
User = mongoose.model('User')

router.route('/tasks').get (req, res, next) ->
  if req.user?
    tasks = Task.find
      user: req.user._id
    , (err, tasks)->
      res.json
        tasks: tasks
  else
    res.status 404
    next()

router.route('/tasks/:user_id').get (req, res, next) ->
  User.findById req.params.user_id, (err, user) ->
    tasks = Task.find
      user: req.user._id
    , (err, tasks)->
      res.json
        tasks: tasks

module.exports = router
