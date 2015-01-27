Stack           = require 'data/schemas/Stack'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateStackStatement extends CreateStatement

  constructor: (data) ->
    super(Stack, data)

module.exports = CreateStackStatement
