CreateCommand = require 'data/framework/commands/CreateCommand'
Card          = require 'data/schemas/Card'

class CreateCardCommand extends CreateCommand

  constructor: (card) ->
    super(Card, card)

module.exports = CreateCardCommand
