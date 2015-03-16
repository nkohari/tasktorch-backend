r                   = require 'rethinkdb'
Action              = require 'data/documents/Action'
Checklist           = require 'data/documents/Checklist'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class RemoveActionFromChecklistsStatement extends BulkUpdateStatement

  constructor: (actionid) ->
    match = r.table(Checklist.getSchema().table).getAll(actionid, {index: 'actions'})
    patch = {actions: r.row('actions').difference([actionid])}
    super(Checklist, match, patch)

module.exports = RemoveActionFromChecklistsStatement
