Bookshelf = require '../bookshelf'
Document = require '../models/document'
React = require 'react'
Page = require '../components/page'

renderDoc = (doc) -> React.renderToString React.createElement Page, doc.toJSON()

exports.dynamic = (req, res) ->
  res.render "layout",
    title: "Page"
    content: React.renderToString React.createElement Page, id: 'none'

exports.index = (req, res) ->
  Document.Collection.forge()
    .query (q) -> q.orderBy('created_at', 'desc')
    .fetch()
    .then (docs) ->
      res.format
        html: ->
          res.render "layout",
            title: "index"
            content: docs.map(renderDoc).join('\n')
        json: ->
          res.send docs.toJSON()
    .done()

exports.doc = (req, res) ->
  {id} = req.params
  Document
    .where({id})
    .fetch()
    .then (doc) ->
      res.format
        html: ->
          res.render "layout",
            title: "Document #{id}: #{doc.get 'name'}"
            content: renderDoc(doc)
        json: ->
          res.send doc.toJSON()
    .done()

exports.test = (req, res) -> res.send('Hello World!')
