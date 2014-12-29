Command                 = require 'domain/Command'
CommandResult           = require 'domain/CommandResult'
CreateSessionStatement  = require 'data/statements/CreateSessionStatement'

class CreateSessionCommand extends Command

  constructor: (@data) ->

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new CreateSessionStatement(@data)
    conn.execute statement, (err, session) =>
      return callback(err) if err?
      result.session = session
      callback(null, result)

module.exports = CreateSessionCommand
