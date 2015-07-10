Command         = require 'domain/framework/Command'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeKindNameCommand extends Command

  constructor: (@user, @kind, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Kind, @kind.id, {@name})
    conn.execute statement, (err, kind) =>
      return callback(err) if err?
      callback(null, kind)

module.exports = ChangeKindNameCommand
