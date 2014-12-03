Bookshelf = require '../bookshelf'
{knex} = Bookshelf
_ = require 'lodash'
React = require 'react'
Promise = require 'bluebird'

Document = require '../models/document'
Article = require '../components/article'
Page = require '../components/page'

render = (component, props) ->
  React.renderToString React.createElement component, props

respondWithArticle = (req, res, doc) ->
  config = req.app.get('config')
  res.format
    html: ->
      res.render "layout",
        title: "#{config?.siteTitle} | #{doc.get 'name'}"
        content: render Article, doc.toJSON()
    json: ->
      res.send doc.toJSON()

pathsDocuments = null # cache
getPathsDocuments = ->
  if pathsDocuments?
    return Promise.resolve pathsDocuments

  pathsDocuments = {}
  knex('documents')
    .select(knex.raw("doc->>'path' as path"), 'id')
    .then (rows) ->
      rows.forEach (row) ->
        pathsDocuments[row.path] = row.id
      pathsDocuments

fetchDocForId = (id) ->  
  Document
    .where({id})
    .fetch()

lookupDocForPath = (reqPath) -> 
  getPathsDocuments()
    .then (pathsDocuments) ->
      id = pathsDocuments[reqPath]
      unless id?
        return Promise.reject reqPath

      fetchDocForId(id)

dynamic = (req, res) ->
  lookupDocForPath(req.path)
    .then (doc) ->
      respondWithArticle(req, res, doc)
    .done()

index = (req, res) ->
  config = req.app.get('config')

  Document.Collection.forge()
    .query (q) -> q.orderBy('created_at', 'desc')
    .fetch()
    .then (docs) ->
      res.format
        html: ->
          title = config?.siteTitle

          res.render "layout",
            title: title
            content: render Page, {title, docs: docs.toJSON()}
        json: ->
          res.send docs.toJSON()
    .done()

show = (req, res) ->
  {id} = req.params
  fetchDocForId(id)
    .then (doc) ->
      respondWithArticle(req, res, doc)
    .done()

module.exports = (app, base) ->
  app.get "#{base}/:id", show
  app.get base, index
_.extend module.exports, {dynamic, index, show}

