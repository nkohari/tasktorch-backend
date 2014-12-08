r         = require 'rethinkdb'
Expansion = require './Expansion'

class HasManyForeignExpansion extends Expansion

  getMergeFunction: ->
    return (parent) =>
      schema    = @relation.getSchema()
      statement = r.table(schema.table).getAll(parent('id'), {index: @relation.index}).coerceTo('array')
      return r.object(
        @field,
        @expand(statement)
      )

module.exports = HasManyForeignExpansion
