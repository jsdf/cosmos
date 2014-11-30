Bookshelf = require '../bookshelf'
_ = require 'lodash'

class Document extends Bookshelf.Model
  tableName: "documents"
  hasTimestamps: ['created_at', 'updated_at']
  parse: (attrs) ->
    _.extend {}, attrs, {doc: JSON.parse attrs.doc} 


class Document.Collection extends Bookshelf.Collection
  model: Document

module.exports = Document
