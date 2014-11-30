Knex = require('knex')(require('./knexfile')[process.env.NODE_ENV or 'development'])
Bookshelf = require("bookshelf")(Knex)

module.exports = Bookshelf
