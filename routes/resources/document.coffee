Bookshelf = require '../../bookshelf'
{knex} = Bookshelf
_ = require 'lodash'
React = require 'react'
Promise = require 'bluebird'

Document = require '../../models/document'

fetchDocForId = (id) ->  
  Document
    .where({id})
    .fetch()

index = (req, res) ->
  Document.Collection.forge()
    .query (q) -> q.orderBy('created_at', 'desc')
    .fetch()
    .then (docs) ->
      res.send docs.toJSON()
    .catch -> res.send 500

show = (req, res) ->
  {id} = req.params
  fetchDocForId(id)
    .then (doc) ->
      res.send doc.toJSON()
    .catch -> res.send 500

create = (req, res) ->
  return res.send(400) if not req.body? or req.body.id?

  Document.forge(_.omit(req.body, 'id')).save()
    .then (doc) ->
      res.send doc.toJSON()
    .catch -> res.send 500

update = (req, res) ->
  {id} = req.params
  return res.send(400) unless id? and req.body?

  fetchDocForId(id)
    .catch Document.NotFoundError, (err) ->
      res.send(404);
    .then (doc) ->
      doc.set(_.omit(req.body, 'id')) # lol mass assignment
      doc.save()
    .then (doc) ->
      res.send doc.toJSON()
    .catch -> res.send 500

destroy = (req, res) ->
  {id} = req.params
  return res.send(400) unless id?

  fetchDocForId(id)
    .catch Document.NotFoundError, (err) ->
      res.send(404);
    .then (doc) ->
      doc.destroy()
    .then (doc) ->
      res.send(204)
    .catch -> res.send 500

module.exports = {index, show, create, update, destroy}
