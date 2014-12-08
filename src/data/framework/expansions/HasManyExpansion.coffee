r         = require 'rethinkdb'
Expansion = require './Expansion'

class HasManyExpansion extends Expansion

  getMergeFunction: ->
    return (parent) =>
      schema    = @relation.getSchema()
      statement = r.table(schema.table).getAll(r.args(parent(@field))).coerceTo('array')
      return r.object(
        @field,
        r.branch(
          r.or(parent.hasFields(@field).not(), parent(@field).eq(null), parent(@field).count().eq(0)),
          [],
          @expand(statement)
        )
      )

module.exports = HasManyExpansion
