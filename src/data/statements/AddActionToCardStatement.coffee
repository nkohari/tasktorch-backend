r               = require 'rethinkdb'
Card            = require 'data/documents/Card'
UpdateStatement = require 'data/statements/UpdateStatement'

class AddActionToCardStatement extends UpdateStatement

  constructor: (actionid, cardid, stageid, position) ->

    patch = (card) -> {
      version: card('version').add(1)
      actions: card('actions').merge((actions) ->
        expr = actions(stageid).default([])
        if position is 'prepend'
          expr = expr.prepend(actionid)
        else if position is 'append'
          expr = expr.append(actionid)
        else
          expr = expr.insertAt(position, actionid) 
        r.object(stageid, expr)
      )
    }

    super(Card, cardid, patch)

module.exports = AddActionToCardStatement
