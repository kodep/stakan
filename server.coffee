config   = require('./config/development')
mongoose = require('mongoose')
dbUri = config.db.mongodb
app = require('./app')
port = 3000

mongoose.connect(dbUri) unless mongoose.connection.readyState

app.listen port, (error) ->
  if (error)
    console.error(error)
  else
    console.info("==> 🌎  Listening on port %s. Open up http://localhost:%s/ in your browser.", port, port)
