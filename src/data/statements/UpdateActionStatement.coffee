Action          = require 'data/documents/Action'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class UpdateActionStatement extends UpdateStatement

  constructor: (id, diff) ->
    super(Action, id, diff)

module.exports = UpdateActionStatement
