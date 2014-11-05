r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Card  = require 'data/schemas/Card'

class GetAllCardsInStackQuery extends Query

  constructor: (stackId, options) ->
    super(Card, options)
    @rql = r.table(Card.table).getAll(stackId, {index: 'stack'}).orderBy('rank')

module.exports = GetAllCardsInStackQuery
