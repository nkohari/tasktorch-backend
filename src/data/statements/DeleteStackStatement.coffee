Stack           = require 'data/schemas/Stack'
DeleteStatement = require 'data/framework/statements/DeleteStatement'

class DeleteStackStatement extends DeleteStatement

  constructor: (data) ->
    super(Stack, data)

module.exports = DeleteStackStatement
