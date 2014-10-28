UpdateCommand = require 'data/framework/commands/UpdateCommand'
User          = require 'data/schemas/User'

class ChangeUserPasswordCommand extends UpdateCommand

  constructor: (cardId, password, expectedVersion) ->
    super(User, cardId, {password}, expectedVersion)

module.exports = ChangeUserPasswordCommand
