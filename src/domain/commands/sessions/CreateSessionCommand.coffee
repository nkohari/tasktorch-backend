Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateSessionCommand extends Command

  constructor: (@user, @session) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@session)
    conn.execute statement, (err, session) =>
      return callback(err) if err?
      callback(null, session)

module.exports = CreateSessionCommand
