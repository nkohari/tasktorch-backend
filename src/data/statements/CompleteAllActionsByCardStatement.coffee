r                   = require 'rethinkdb'
Action              = require 'data/documents/Action'
ActionStatus        = require 'data/enums/ActionStatus'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class CompleteAllActionsByCardStatement extends BulkUpdateStatement

  constructor: (cardid) ->
    match = r.table(Action.getSchema().table).getAll(cardid, {index: 'card'})
    patch = {
      status:    ActionStatus.Complete
      completed: r.now()
    }
    super(Action, match, patch)

module.exports = CompleteAllActionsByCardStatement
