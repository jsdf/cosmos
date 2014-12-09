Events = require 'backbone-events-standalone'

class Store
  Events.mixin @prototype

  constuctor: ->
    @_value = null

  set: (newValue) ->
    @_value = newValue
    @trigger 'change'

  get: -> @_value

module.exports = Store