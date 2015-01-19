r               = require 'rethinkdb'
Card            = require 'data/schemas/Card'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class AddActionToCardStatement extends UpdateStatement

  constructor: (actionId, cardId, stageId, position) ->

    patch = (card) -> {
      version: card('version').add(1)
      actions: card('actions').merge((actions) ->
        expr = actions(stageId).default([])
        if position is 'prepend'
          expr = expr.prepend(actionId)
        else if position is 'append'
          expr = expr.append(actionId)
        else
          expr = expr.insertAt(position, actionId) 
        r.object(stageId, expr)
      )
    }

    super(Card, cardId, patch)

module.exports = AddActionToCardStatement
