Command         = require 'domain/framework/Command'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeKindColorCommand extends Command

  constructor: (@user, @kind, @color) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Kind, @kind.id, {@color})
    conn.execute statement, (err, kind) =>
      return callback(err) if err?
      callback(null, kind)

module.exports = ChangeKindColorCommand
