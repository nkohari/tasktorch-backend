r                   = require 'rethinkdb'
Card                = require 'data/documents/Card'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class RemoveAllCardsFromGoalStatement extends BulkUpdateStatement

  constructor: (goalid) ->
    match = r.table(Card.getSchema().table).getAll(goalid, {index: 'goals'})
    patch = {goals: r.row('goals').setDifference([goalid])}
    super(Card, match, patch)

module.exports = RemoveAllCardsFromGoalStatement
