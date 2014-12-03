express = require 'express'
fs = require 'fs'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
methodOverride = require 'method-override'
session = require 'express-session'
bodyParser = require 'body-parser'
formData = require 'multer'
errorHandler =  require 'errorhandler'
lessMiddleware = require 'less-middleware'
extensionToAccept = require 'express-extension-to-accept'

ansiCyan = '\x1B[0;36m'
ansiReset = '\x1B[0m'
config = require './config'

# all environments
port = process.env.PORT or config.port or 3000
app = express()
app.set 'config', config
app.set 'view engine', 'hjs'
app.set 'views', path.join(__dirname, 'views')
app.use favicon(__dirname + '/public/favicon.ico')
app.use logger('dev')
app.use methodOverride()
app.use extensionToAccept [
  'html',
  'json',
]
app.use session {
  resave: true
  saveUninitialized: true
  secret: config.sessionSecret
}
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use formData()
app.use lessMiddleware(__dirname + '/public')
app.use express.static(path.join(__dirname, 'public'))

console.log 'env', app.get('env')
if 'development' is app.get('env')
  app.use errorHandler() # development only

# register routes
require('./routes/resources/document')(app, '/resource/doc')
require('./routes/admin')(app, '/admin')
documentRoutes = require('./routes/document')
documentRoutes(app, '/doc')
app.get '/', documentRoutes.index
app.get '/*', documentRoutes.dynamic

app.listen port, ->
  console.log "#{ansiCyan}cosmos#{ansiReset} flowing through port #{port}"

process.on 'uncaughtException', (e) -> console.error e.stack
