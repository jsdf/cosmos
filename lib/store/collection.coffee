Events = require 'backbone-events-standalone'
assertExists = require 'lib/util/assert-exists'
_ = require 'lodash'

class Store
  Events.mixin @prototype

  constuctor: ->
    @_value = {}

  reset: (newCollection) ->
    assertExists newCollection
    if _.isArray(newCollection)
      newCollection = _.indexBy(newCollection, 'id')

    @_value = newCollection
    @trigger 'change'
    newCollection

  set: (item) ->
    assertExists item
    @_value[item.id] = item
    @trigger 'change'
    item

  get: (id) ->
    assertExists id
    @_value[id]

  remove: (id) ->
    if _.isObject(id)
      id = id.id
    assertExists id
    itemToDelete = @_value[id]
    delete @_value[id]
    @trigger 'change'
    itemToDelete

module.exports = Store