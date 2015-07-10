r                   = require 'rethinkdb'
Action              = require 'data/documents/Action'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class MoveAllActionsToAnotherStageStatement extends BulkUpdateStatement

  constructor: (fromStageId, toStageId) ->
    match = r.table(Action.getSchema().table).getAll(fromStageId, {index: 'stage'})
    patch = {stage: toStageId}
    super(Action, match, patch)

module.exports = MoveAllActionsToAnotherStageStatement
