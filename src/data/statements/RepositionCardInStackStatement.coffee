r               = require 'rethinkdb'
Stack           = require 'data/documents/Stack'
UpdateStatement = require 'data/statements/UpdateStatement'

class RepositionCardInStackStatement extends UpdateStatement

  constructor: (stackid, cardid, position) ->

    arg = r.row('cards').difference([cardid])

    if position is 'prepend'
      arg = arg.prepend(cardid)
    else if position is 'append'
      arg = arg.append(cardid)
    else
      arg = arg.insertAt(position, cardid)

    super(Stack, stackid, {cards: arg})

module.exports = RepositionCardInStackStatement
