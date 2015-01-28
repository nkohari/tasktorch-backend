r                   = require 'rethinkdb'
Card                = require 'data/schemas/Card'
Stack               = require 'data/schemas/Stack'
BulkUpdateStatement = require 'data/framework/statements/BulkUpdateStatement'

class RemoveCardFromStacksStatement extends BulkUpdateStatement

  constructor: (cardid) ->
    match = r.table(Stack.table).getAll(cardid, {index: 'cards'})
    patch = {cards: r.row('cards').difference([cardid])}
    super(Stack, match, patch)

module.exports = RemoveCardFromStacksStatement
