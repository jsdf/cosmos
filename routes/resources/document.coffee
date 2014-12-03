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
    .done()

show = (req, res) ->
  {id} = req.params
  fetchDocForId(id)
    .then (doc) ->
      res.send doc.toJSON()
    .done()

create = (req, res) ->
  return res.send(400) if not req.body? or req.body.id?

  Document.forge(_.omit(req.body, 'id')).save()
    .then (doc) ->
      res.send doc.toJSON()
    .done()

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
    .done()

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
    .done()

module.exports = (app, base) ->
  app.get base, index
  app.route("#{base}/:id")
    .get show
    .post create
    .put update
    .delete destroy
_.extend module.exports, {index, show, create, update, destroy}
