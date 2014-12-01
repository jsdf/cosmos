Bookshelf = require './bookshelf'
Document = require './models/document'
path = require 'path'
Promise = require 'bluebird'
fs = require 'fs'
Promise.promisifyAll(fs)
_ = require 'lodash'
url = require 'url'

importDir = path.resolve process.argv[2]

importContentOfType = (type) ->
  typedir = path.join importDir, type
  _.object _.map (fs.readdirSync typedir), (filename) ->
    [(path.basename filename, '.json'),(require path.join typedir, filename)]

nodes = importContentOfType 'node'
terms = importContentOfType 'taxonomy_term'

Promise.map(_.pairs(nodes), ([id, doc]) ->
  console.log(id, _.keys doc)
  d = Document.forge(
    doc:
      author: doc.name
      type: doc.type
      body: doc.body?['und']?[0]?['value']
      field_image: doc.field_image?['und']?.map((item) ->
        filename: item.filename
        uri: url.parse(item.uri).path
        filemime: item.filemime
        filesize: item.filesize
        alt: item.alt
        title: item.title
        width: item.width
        height: item.height
      )[0] or null
      field_tags: _.compact(doc.field_tags?['und']?.map((item) -> terms[item.tid]?.name) or [])
      path:
        if doc.path?
          url.parse(doc.path).path
        else
          null
    name: doc.title
    created_at: new Date parseInt(doc.created)*1000
    updated_at: new Date parseInt(doc.changed)*1000
  )
  d.hasTimestamps = false
  d.save()
)
  .then ->
    console.log 'import done'
    Bookshelf.knex.destroy()
