r      = require 'rethinkdb'
Query  = require 'data/framework/queries/Query'
Action = require 'data/schemas/Action'
Card   = require 'data/schemas/Card'

class GetAllActionsByCardQuery extends Query

  constructor: (cardid, options) ->
    super(Action, options)
    ids = r.table(Card.table).get(cardid)('actions').do((actions) ->
      actions.keys()
        .map (key) -> actions(key)
        .reduce (left, right) -> left.setUnion(right)
    ).coerceTo('array').default([])
    @rql = r.branch(
      ids.isEmpty(), [],
      r.table(Action.table).getAll(r.args(ids)).coerceTo('array')
    )

module.exports = GetAllActionsByCardQuery
