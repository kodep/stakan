mongoose              = require('mongoose')
Schema                = mongoose.Schema
ObjectId              = Schema.ObjectId

Task = new mongoose.Schema
  content: String
  user:
    type: ObjectId
    ref: 'User'
  author:
    type: ObjectId
    ref: 'User'

module.exports = mongoose.model('Task', Task)
