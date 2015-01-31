Command                = require 'domain/framework/Command'
CreateSessionStatement = require 'data/statements/CreateSessionStatement'

class CreateSessionCommand extends Command

  constructor: (@user, @session) ->

  execute: (conn, callback) ->
    statement = new CreateSessionStatement(@session)
    conn.execute statement, (err, session) =>
      return callback(err) if err?
      callback(null, session)

module.exports = CreateSessionCommand
