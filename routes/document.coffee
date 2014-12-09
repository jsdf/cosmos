Bookshelf = require '../bookshelf'
{knex} = Bookshelf
_ = require 'lodash'
React = require 'react'
Promise = require 'bluebird'

Document = require '../models/document'
Article = require '../components/article'
ArticlePage = require '../components/article-page'
makeErrorHandler = require '../lib/util/make-error-handler'

getPathsDocumentIds = do ->
  pathsDocumentIds = null # cache
  ->
    if pathsDocumentIds?
      return Promise.resolve pathsDocumentIds

    pathsDocumentIds = {}
    knex('documents')
      .select(knex.raw("doc->>'path' as path"), 'id')
      .then (rows) ->
        rows.forEach (row) ->
          pathsDocumentIds[row.path] = row.id
        pathsDocumentIds

renderComponent = (component, props) ->
  React.renderToString React.createElement component, props

respondWithArticle = (req, res, doc) ->
  config = req.app.get('config')
  res.format
    html: ->
      res.render 'layout',
        title: "#{config?.siteTitle} | #{doc.get 'name'}"
        content: renderComponent Article, doc.toJSON()
    json: ->
      res.send doc.toJSON()

fetchDocForId = (id) ->  
  Document
    .where({id})
    .fetch()

lookupDocForPath = (reqPath) -> 
  getPathsDocumentIds()
    .then (pathsDocumentIds) ->
      id = pathsDocumentIds[reqPath]
      unless id?
        return Promise.reject reqPath

      fetchDocForId(id)

dynamic = (req, res, next) ->
  lookupDocForPath(req.path)
    .then (doc) ->
      respondWithArticle(req, res, doc)
    .catch makeErrorHandler(req, res, next)

index = (req, res, next) ->
  config = req.app.get('config')

  Document.Collection.forge()
    .query (q) -> q.orderBy('created_at', 'desc')
    .fetch()
    .then (docs) ->
      res.format
        html: ->
          title = config?.siteTitle
          tagline = config?.siteTagline

          res.render 'layout',
            title: "#{title} | #{tagline}"
            content: renderComponent ArticlePage, {title, tagline, docs: docs.toJSON()}
        json: ->
          res.send docs.toJSON()
    .catch makeErrorHandler(req, res, next)

show = (req, res, next) ->
  {id} = req.params
  fetchDocForId(id)
    .then (doc) ->
      respondWithArticle(req, res, doc)
    .catch makeErrorHandler(req, res, next)

module.exports = {dynamic, index, show}

