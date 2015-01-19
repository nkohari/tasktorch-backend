Action          = require 'data/schemas/Action'
DeleteStatement = require 'data/framework/statements/DeleteStatement'

class DeleteActionStatement extends DeleteStatement

  constructor: (id) ->
    super(Action, id)

module.exports = DeleteActionStatement
