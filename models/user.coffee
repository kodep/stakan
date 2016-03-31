mongoose              = require('mongoose')
Schema                = mongoose.Schema
passportLocalMongoose = require('passport-local-mongoose')

User = new mongoose.Schema {}

User.plugin(passportLocalMongoose)

module.exports = mongoose.model('User', User)
