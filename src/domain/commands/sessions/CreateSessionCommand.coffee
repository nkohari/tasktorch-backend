Command                 = require 'domain/framework/Command'
CommandResult           = require 'domain/framework/CommandResult'
CreateSessionStatement  = require 'data/statements/CreateSessionStatement'

class CreateSessionCommand extends Command

  constructor: (@user, @session) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new CreateSessionStatement(@session)
    conn.execute statement, (err, session) =>
      return callback(err) if err?
      result.session = session
      callback(null, result)

module.exports = CreateSessionCommand
