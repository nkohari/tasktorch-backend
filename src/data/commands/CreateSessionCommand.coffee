CreateCommand = require 'data/framework/commands/CreateCommand'
Session       = require 'data/schemas/Session'

class CreateSessionCommand extends CreateCommand

  constructor: (session) ->
    super(Session, session)

module.exports = CreateSessionCommand
