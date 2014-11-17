r      = require 'rethinkdb'
Query  = require 'data/framework/queries/Query'
Action = require 'data/schemas/Action'

class GetAllActionsByCardQuery extends Query

  constructor: (cardId, options) ->
    super(Action, options)
    @rql = r.table(Action.table).getAll(cardId, {index: 'card'}).orderBy('rank')

module.exports = GetAllActionsByCardQuery
