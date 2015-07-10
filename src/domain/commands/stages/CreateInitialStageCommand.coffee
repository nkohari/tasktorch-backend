CreateStatement = require 'data/statements/CreateStatement'
Command         = require 'domain/framework/Command'

class CreateInitialStageCommand extends Command

  constructor: (@user, @stage, @position = 'append') ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@stage)
    conn.execute statement, (err, stage) =>
      return callback(err) if err?
      callback(null, stage)

module.exports = CreateInitialStageCommand
