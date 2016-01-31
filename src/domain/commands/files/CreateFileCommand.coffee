CreateStatement = require 'data/statements/CreateStatement'
Command         = require 'domain/framework/Command'

class CreateFileCommand extends Command

  constructor: (@user, @file) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@file)
    conn.execute statement, (err, file) =>
      return callback(err) if err?
      callback(null, file)

module.exports = CreateFileCommand
