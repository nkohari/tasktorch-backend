CreateStatement = require 'data/statements/CreateStatement'
Command         = require 'domain/framework/Command'

class CreateKindCommand extends Command

  constructor: (@user, @kind) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@kind)
    conn.execute statement, (err, kind) =>
      return callback(err) if err?
      callback(null, kind)

module.exports = CreateKindCommand
