DocumentStatus  = require 'data/enums/DocumentStatus'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class DeleteStatement extends UpdateStatement

  constructor: (doctype, id) ->
    super(doctype, id, {status: DocumentStatus.Deleted})

module.exports = DeleteStatement
