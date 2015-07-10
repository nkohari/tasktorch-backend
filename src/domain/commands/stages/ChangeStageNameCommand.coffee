Command         = require 'domain/framework/Command'
Stage           = require 'data/documents/Stage'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeStageNameCommand extends Command

  constructor: (@user, @stage, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Stage, @stage.id, {@name})
    conn.execute statement, (err, stage) =>
      return callback(err) if err?
      callback(null, stage)

module.exports = ChangeStageNameCommand
