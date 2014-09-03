
exports.up = (knex, Promise) ->
  knex.schema.createTable 'documents', (table) ->
    table.increments().primary()
    table.string('name')
    table.specificType('doc', 'jsonb')
    table.timestamps()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('documents')
