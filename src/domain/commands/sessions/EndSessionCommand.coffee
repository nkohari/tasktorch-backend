Command                = require 'domain/framework/Command'
UpdateSessionStatement = require 'data/statements/UpdateSessionStatement'

class EndSessionCommand extends Command

  constructor: (@user, @sessionid) ->

  execute: (conn, callback) ->
    statement = new UpdateSessionStatement(@sessionid, {isActive: false})
    conn.execute statement, (err, session) =>
      return callback(err) if err?
      callback(null, session)

module.exports = EndSessionCommand
