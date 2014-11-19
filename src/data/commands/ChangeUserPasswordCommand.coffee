UpdateCommand = require 'data/framework/commands/UpdateCommand'
User          = require 'data/schemas/User'

class ChangeUserPasswordCommand extends UpdateCommand

  constructor: (userId, password, expectedVersion) ->
    super(User, userId, {password}, expectedVersion)

module.exports = ChangeUserPasswordCommand
