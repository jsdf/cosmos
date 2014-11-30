express = require('express')
fs = require('fs')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
methodOverride = require('method-override')
session = require('express-session')
bodyParser = require('body-parser')
formData = require('multer')
errorHandler =  require('errorhandler')
lessMiddleware = require('less-middleware')
app = express()

# all environments
port = process.env.PORT or 3000
app.set 'port', port
app.set 'view engine', 'hjs'
app.set 'views', path.join(__dirname, 'views')
app.use favicon(__dirname + '/public/favicon.ico')
app.use logger('dev')
app.use methodOverride()
app.use session(
  resave: true
  saveUninitialized: true
  secret: '123456'
)
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use formData()
app.use lessMiddleware(__dirname + '/public')
app.use express.static(path.join(__dirname, 'public'))

# development only
app.use errorHandler() if 'development' is app.get('env')

routes = require('./routes')
app.get '/doc', routes.index
app.get '/doc/:id', routes.doc
app.get '/*', routes.dynamic

app.set 'bookshelf', require('./bookshelf')
app.set 'models', fs.readdirSync('./models').reduce((models, filename) ->
  name = path.basename(filename, path.extname(filename))
  models[name] = require("./models/#{filename}")
, {})

app.listen port, ->
  console.log "Express server listening on port #{port}"