r                   = require 'rethinkdb'
Action              = require 'data/documents/Action'
Card                = require 'data/documents/Card'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class RemoveActionFromCardStatement extends BulkUpdateStatement

  constructor: (actionid) ->
    match = r.table(Card.getSchema().table).getAll(actionid, {index: 'actions'})
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
