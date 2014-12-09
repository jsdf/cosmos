express = require 'express'
fs = require 'fs'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
methodOverride = require 'method-override'
session = require 'express-session'
bodyParser = require 'body-parser'
formData = require 'multer'
expressError = require 'express-error'
lessMiddleware = require 'less-middleware'
extensionToAccept = require 'express-extension-to-accept'

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
app.get '/assets/:filename', require('./asset-build')
app.use lessMiddleware(__dirname + '/public')
app.use express.static(path.join(__dirname, 'public'))

console.log 'env', app.get('env')
if 'development' is app.get('env')
  app.set 'errorHandler', expressError.express3({contextLinesCount: 3, handleUncaughtException: true})
  app.use app.get 'errorHandler'
else
  app.set 'errorHandler', (err, req, res, next) ->
    res.sendStatus 500

# register routes
app.get '/schemas', require('./routes/schemas')

do ->
  {index, show, create, update, destroy} = require('./routes/resources/document')
  app.get '/resource/doc', index
  app.route('/resource/doc/:id')
    .get show
    .post create
    .put update
    .delete destroy

do ->
  {index} = require('./routes/admin')
  app.get '/admin', index

do ->
  {dynamic, index, show} = require('./routes/document')
  app.get '/doc/:id', show
  app.get '/doc', index
  app.get '/', index
  app.get '/*', dynamic

app.listen port, ->
  ansiCyan = '\x1B[0;36m'
  ansiReset = '\x1B[0m'
  console.log "#{ansiCyan}cosmos#{ansiReset} event horizon on port #{port}"
