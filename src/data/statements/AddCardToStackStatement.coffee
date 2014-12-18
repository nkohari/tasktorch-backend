r               = require 'rethinkdb'
Stack           = require 'data/schemas/Stack'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class AddCardToStackStatement extends UpdateStatement

  constructor: (stackId, cardId, position) ->

    if position is 'prepend'
      arg = r.row('cards').prepend(cardId)
    else if position is 'append'
      arg = r.row('cards').append(cardId)
    else
      arg = r.row('cards').insertAt(position, cardId)

    super(Stack, stackId, {cards: arg})

module.exports = AddCardToStackStatement
