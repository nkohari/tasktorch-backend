UpdateCommand = require 'data/framework/commands/UpdateCommand'
User          = require 'data/schemas/User'

class ChangeUserNameCommand extends UpdateCommand

  constructor: (userId, name, expectedVersion) ->
    super(User, userId, {name}, expectedVersion)

module.exports = ChangeUserNameCommand
