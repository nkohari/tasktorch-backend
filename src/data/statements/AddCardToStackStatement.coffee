r               = require 'rethinkdb'
Stack           = require 'data/documents/Stack'
UpdateStatement = require 'data/statements/UpdateStatement'

class AddCardToStackStatement extends UpdateStatement

  constructor: (stackid, cardid, position) ->

    if position is 'prepend'
      arg = r.row('cards').prepend(cardid)
    else if position is 'append'
      arg = r.row('cards').append(cardid)
    else
      arg = r.row('cards').insertAt(position, cardid)

    super(Stack, stackid, {cards: arg})

module.exports = AddCardToStackStatement
