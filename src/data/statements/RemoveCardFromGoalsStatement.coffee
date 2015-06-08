r                   = require 'rethinkdb'
Card                = require 'data/documents/Card'
Goal                = require 'data/documents/Goal'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class RemoveCardFromGoalsStatement extends BulkUpdateStatement

  constructor: (cardid) ->
    match = r.table(Goal.getSchema().table).getAll(cardid, {index: 'cards'})
    patch = {cards: r.row('cards').difference([cardid])}
    super(Goal, match, patch)

module.exports = RemoveCardFromGoalsStatement
