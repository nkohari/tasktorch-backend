DocumentStatus  = require 'data/DocumentStatus'
UpdateStatement = require './UpdateStatement'

class DeleteStatement extends UpdateStatement

  constructor: (schema, id) ->
    super(schema, id, {status: DocumentStatus.Deleted})

module.exports = DeleteStatement
