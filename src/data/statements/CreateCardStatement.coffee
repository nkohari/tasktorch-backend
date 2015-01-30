Card            = require 'data/documents/Card'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateCardStatement extends CreateStatement

  constructor: (data) ->
    super(Card, data)

module.exports = CreateCardStatement
