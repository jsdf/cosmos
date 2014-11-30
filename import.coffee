Bookshelf = require './bookshelf'
Document = require './models/document'
path = require 'path'
Promise = require 'bluebird'
fs = require 'fs'
Promise.promisifyAll(fs)

Documents = Bookshelf.Collection.extend
  model: Document

docs = new Documents

importDir = path.resolve process.argv[2]

# Promise.map(fs.readdirSync(importDir), (filename) ->
#   doc = require(path.join importDir, filename)
#   Document.forge({doc}).save()
# )
#   .then ->
#     console.log 'import done'
      
docs.fetch()
  .then ->
    docs.mapThen (doc) ->
      doc.set('name', doc.get('doc')?.title)
      console.log 'title', doc.get('name')

      doc.save()
    .catch (e) -> console.error e
    .then -> console.log 'end'
  .done()