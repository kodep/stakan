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

router.post(
  '/tasks',
  passport.authenticate('http-header-token'),
  (req, res, next) ->
    currentUser = req.user
    task = new Task
      content: req.body.content
      author:  currentUser._id
      user:    req.body.user_id
    task.save()
    res.json task
)

userInvolvedInTask = (user, task) ->
  userId = user._id.toString()
  task.author.toString() == userId || task.user.toString() == userId

router.delete(
  '/tasks/:task_id',
  passport.authenticate('http-header-token'),
  (req, res, next) ->
    currentUser = req.user
    Task.findById req.params.task_id
    .then (task, err) ->
      if userInvolvedInTask(currentUser, task)
        task.remove()
        .then ->
          res.json task
      else
        res.status(401).json
          error: 'Forbidden'
)

module.exports = router
