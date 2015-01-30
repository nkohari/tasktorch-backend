Session         = require 'data/documents/Session'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateSessionStatement extends CreateStatement

  constructor: (data) ->
    super(Session, data)

module.exports = CreateSessionStatement
