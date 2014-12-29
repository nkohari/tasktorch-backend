Card            = require 'data/schemas/Card'
DeleteStatement = require 'data/framework/statements/DeleteStatement'

class DeleteCardStatement extends DeleteStatement

  constructor: (id) ->
    super(Card, id)

module.exports = DeleteCardStatement
