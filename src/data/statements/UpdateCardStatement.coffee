Card            = require 'data/documents/Card'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class UpdateCardStatement extends UpdateStatement

  constructor: (id, diff) ->
    super(Card, id, diff)

module.exports = UpdateCardStatement
