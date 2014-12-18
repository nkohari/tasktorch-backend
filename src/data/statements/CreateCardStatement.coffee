Card            = require 'data/schemas/Card'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateCardStatement extends CreateStatement

  constructor: (data) ->
    super(Card, data)

module.exports = CreateCardStatement
