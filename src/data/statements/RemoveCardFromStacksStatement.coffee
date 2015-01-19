r                   = require 'rethinkdb'
Card                = require 'data/schemas/Card'
Stack               = require 'data/schemas/Stack'
BulkUpdateStatement = require 'data/framework/statements/BulkUpdateStatement'

class RemoveCardFromStacksStatement extends BulkUpdateStatement

  constructor: (cardId) ->
    match = r.table(Stack.table).getAll(cardId, {index: 'cards'})
    patch = {cards: r.row('cards').difference([cardId])}
    super(Stack, match, patch)

module.exports = RemoveCardFromStacksStatement
