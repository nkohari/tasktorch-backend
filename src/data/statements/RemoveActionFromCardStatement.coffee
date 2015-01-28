r                   = require 'rethinkdb'
Action              = require 'data/schemas/Action'
Card                = require 'data/schemas/Card'
BulkUpdateStatement = require 'data/framework/statements/BulkUpdateStatement'

class RemoveActionFromCardStatement extends BulkUpdateStatement

  constructor: (actionid) ->
    match = r.table(Card.table).getAll(actionid, {index: 'actions'})
    patch = (card) -> {
      version: card('version').add(1)
      actions: card('actions').merge((actions) ->
        actions.keys().map((key) ->
          r.expr [key, actions(key).setDifference([actionid])]
        ).coerceTo('object')
      )
    }
    super(Card, match, patch)

module.exports = RemoveActionFromCardStatement
