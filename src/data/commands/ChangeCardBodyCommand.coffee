UpdateCommand = require 'data/framework/commands/UpdateCommand'
Card          = require 'data/schemas/Card'

class ChangeCardBodyCommand extends UpdateCommand

  constructor: (cardId, body, expectedVersion) ->
    super(Card, cardId, {body}, expectedVersion)

module.exports = ChangeCardBodyCommand
