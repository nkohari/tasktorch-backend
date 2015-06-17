r                   = require 'rethinkdb'
Card                = require 'data/documents/Card'
Stack               = require 'data/documents/Stack'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class RemoveCardFromStacksStatement extends BulkUpdateStatement

  constructor: (cardid) ->
    match = r.table(Stack.getSchema().table).getAll(cardid, {index: 'cards'})
    patch = {cards: r.row('cards').difference([cardid])}
    super(Stack, match, patch)

module.exports = RemoveCardFromStacksStatement
