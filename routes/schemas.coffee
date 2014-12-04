path = require 'path'
fs = require 'fs'
Promise = require 'bluebird'
Promise.promisifyAll(fs)

module.exports = (req, res, next) ->
  schemas = {}
  fs.readdirAsync('./schemas')
    .map (filename) ->
      name = path.basename(filename, path.extname(filename))
      fs.readFileAsync("./schemas/#{filename}", encoding: 'utf8')
        .then (contents) ->
          schemas[name] = JSON.parse contents
    .then ->
      res.send schemas
    .catch -> res.send 500
