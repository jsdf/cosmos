CollectionStore = require 'lib/store/collection'
Model = require 'lib/rest-model'
XHR = require 'lib/xhr'
_ = require 'lodash'

class DocumentStore extends CollectionStore
  restSpec:
    urlRoot: '/resource/doc'

  fetchAll: ->
    XHR.getJSON(@restSpec.urlRoot)
      .then (items) => @reset(items)

  decorate: (item) ->
    @Model ?= Model.extend(@restSpec)
    @Model.new(item)

  create: (item) -> @save(_.omit(item, 'id'))

  update: (item) -> @save(item)

  destroy: ->
    restItem = @decorate(item)
    restItem.destroy()
      .then (destroyedItem) =>
        @remove(destroyedItem)

  save: (item) ->
    restItem = @decorate(item)
    restItem.save()
      .then (savedItem) =>
        @set(savedItem)

module.exports = new DocumentStore
