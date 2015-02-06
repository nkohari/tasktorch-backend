DocumentStatus  = require 'data/enums/DocumentStatus'
UpdateStatement = require 'data/statements/UpdateStatement'

class DeleteStatement extends UpdateStatement

  constructor: (document) ->
    super(document.constructor, document.id, {status: DocumentStatus.Deleted})

module.exports = DeleteStatement
