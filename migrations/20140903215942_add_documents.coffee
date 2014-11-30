
exports.up = (knex, Promise) ->
  knex.schema.createTable 'documents', (table) ->
    table.increments().primary()
    table.string('name')
    table.json('doc', true)
    table.timestamps()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('documents')
