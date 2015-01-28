Command                 = require 'domain/Command'
CommandResult           = require 'domain/CommandResult'
UpdateSessionStatement  = require 'data/statements/UpdateSessionStatement'

class EndSessionCommand extends Command

  constructor: (@user, @sessionid) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateSessionStatement(@sessionid, {isActive: false})
    conn.execute statement, (err, session) =>
      return callback(err) if err?
      result.session = session
      callback(null, result)

module.exports = EndSessionCommand
