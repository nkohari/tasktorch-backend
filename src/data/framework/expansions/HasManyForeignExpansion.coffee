r         = require 'rethinkdb'
Expansion = require './Expansion'

class HasManyForeignExpansion extends Expansion

  getMergeFunction: ->
    return (parent) =>
      schema    = @relation.getSchema()
      statement = r.table(schema.table).getAll(parent('id'), {index: @relation.index})

      if @relation.order?
        direction = @relation.order.direction ? 'desc'
        if direction is 'desc'
          clause = r.desc(@relation.order.field)
        else
          clause = r.asc(@relation.order.field)
        statement = statement.orderBy(clause)

      statement = statement.coerceTo('array')
      return r.object(
        @field,
        @expand(statement)
      )

module.exports = HasManyForeignExpansion
