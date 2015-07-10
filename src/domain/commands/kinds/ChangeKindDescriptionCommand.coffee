Command         = require 'domain/framework/Command'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeKindDescriptionCommand extends Command

  constructor: (@user, @kind, @description) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Kind, @kind.id, {@description})
    conn.execute statement, (err, kind) =>
      return callback(err) if err?
      callback(null, kind)

module.exports = ChangeKindDescriptionCommand
