Action          = require 'data/schemas/Action'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateActionStatement extends CreateStatement

  constructor: (data) ->
    super(Action, data)

module.exports = CreateActionStatement
