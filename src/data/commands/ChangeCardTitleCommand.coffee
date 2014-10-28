UpdateCommand = require 'data/framework/commands/UpdateCommand'
Card          = require 'data/schemas/Card'

class ChangeCardTitleCommand extends UpdateCommand

  constructor: (cardId, title, expectedVersion) ->
    super(Card, cardId, {title}, expectedVersion)

module.exports = ChangeCardTitleCommand
