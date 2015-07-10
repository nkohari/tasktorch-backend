Command            = require 'domain/framework/Command'
MoveStageStatement = require 'data/statements/MoveStageStatement'

class MoveStageCommand extends Command

  constructor: (@user, @stage, @position) ->

  execute: (conn, callback) ->
    statement = new MoveStageStatement(@stage.kind, @stage.id, @position)
    conn.execute statement, (err, stage) =>
      return callback(err) if err?
      callback(null, stage)

module.exports = MoveStageCommand
