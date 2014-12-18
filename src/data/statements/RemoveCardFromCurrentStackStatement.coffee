r               = require 'rethinkdb'
Card            = require 'data/schemas/Card'
Stack           = require 'data/schemas/Stack'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class RemoveCardFromCurrentStackStatement extends UpdateStatement

  constructor: (cardId, position) ->
    id   = r.table(Card.table).get(cardId)('stack')
    diff = {cards: r.row('cards').difference([cardId])}
    super(Stack, id, diff)

module.exports = RemoveCardFromCurrentStackStatement
