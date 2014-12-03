_ = require 'lodash'

index = (req, res) ->
  config = req.app.get('config')
  res.render "admin",
    title: "#{config?.siteTitle} | Admin Area"

module.exports = (app, base) ->
  app.get base, index
_.extend module.exports, {index}
