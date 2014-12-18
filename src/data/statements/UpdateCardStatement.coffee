Card            = require 'data/schemas/Card'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class UpdateCardStatement extends UpdateStatement

  constructor: (id, diff) ->
    super(Card, id, diff)

module.exports = UpdateCardStatement
