r                   = require 'rethinkdb'
Checklist           = require 'data/documents/Checklist'
DocumentStatus      = require 'data/enums/DocumentStatus'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class DeleteAllChecklistsByStageStatement extends BulkUpdateStatement

  constructor: (stageid) ->
    match = r.table(Checklist.getSchema().table).getAll(stageid, {index: 'stage'})
    patch = {actions: [], status: DocumentStatus.Deleted}
    super(Checklist, match, patch)

module.exports = DeleteAllChecklistsByStageStatement
