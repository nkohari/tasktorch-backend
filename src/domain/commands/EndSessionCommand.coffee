Command                 = require 'domain/Command'
CommandResult           = require 'domain/CommandResult'
UpdateSessionStatement  = require 'data/statements/UpdateSessionStatement'

class EndSessionCommand extends Command

  constructor: (@sessionId) ->

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new UpdateSessionStatement(@sessionId, {isActive: false})
    statement.execute conn, (err, session) =>
      return callback(err) if err?
      result.session = session
      callback(null, result)

module.exports = EndSessionCommand
