r                   = require 'rethinkdb'
Note                = require 'data/documents/Note'
DocumentStatus      = require 'data/enums/DocumentStatus'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class DeleteAllNotesByActionStatement extends BulkUpdateStatement

  constructor: (actionid) ->
    match = r.table(Note.getSchema().table).getAll(actionid, {index: 'action'})
    patch = {status: DocumentStatus.Deleted}
    super(Note, match, patch)

module.exports = DeleteAllNotesByActionStatement
