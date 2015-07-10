Command         = require 'domain/framework/Command'
Stage           = require 'data/documents/Stage'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeStageDefaultActionsCommand extends Command

  constructor: (@user, @stage, @defaultActions) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Stage, @stage.id, {@defaultActions})
    conn.execute statement, (err, stage) =>
      return callback(err) if err?
      callback(null, stage)

module.exports = ChangeStageDefaultActionsCommand
