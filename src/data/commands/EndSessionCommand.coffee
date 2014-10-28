UpdateCommand = require 'data/framework/commands/UpdateCommand'
Session       = require 'data/schemas/Session'

class EndSessionCommand extends UpdateCommand

  constructor: (sessionId, expectedVersion) ->
    super(Session, sessionId, {isActive: false}, expectedVersion)

module.exports = EndSessionCommand
