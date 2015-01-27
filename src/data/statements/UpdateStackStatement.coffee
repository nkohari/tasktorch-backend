Stack           = require 'data/schemas/Stack'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class UpdateStackStatement extends UpdateStatement

  constructor: (id, diff) ->
    super(Stack, id, diff)

module.exports = UpdateStackStatement
