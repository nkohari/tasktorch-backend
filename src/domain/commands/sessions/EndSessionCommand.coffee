Command         = require 'domain/framework/Command'
Session         = require 'data/documents/Session'
UpdateStatement = require 'data/statements/UpdateStatement'

class EndSessionCommand extends Command

  constructor: (@user, @sessionid) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Session, @sessionid, {isActive: false})
    conn.execute statement, (err, session) =>
      return callback(err) if err?
      callback(null, session)

module.exports = EndSessionCommand
