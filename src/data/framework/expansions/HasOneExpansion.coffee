r         = require 'rethinkdb'
Expansion = require './Expansion'

class HasOneExpansion extends Expansion

  getMergeFunction: ->
    return (parent) =>
      schema    = @relation.getSchema()
      statement = r.table(schema.table).get(parent(@field))
      return r.object(
        @field,
        r.branch(r.not(parent.hasFields(@field)), null, @expand(statement))
      )

module.exports = HasOneExpansion
