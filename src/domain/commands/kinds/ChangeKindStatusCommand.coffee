Command         = require 'domain/framework/Command'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeKindStatusCommand extends Command

  constructor: (@user, @kind, @status) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Kind, @kind.id, {@status})
    conn.execute statement, (err, kind) =>
      return callback(err) if err?
      callback(null, kind)

module.exports = ChangeKindStatusCommand
