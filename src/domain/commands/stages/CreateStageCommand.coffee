Checklist               = require 'data/documents/Checklist'
AddStageToKindStatement = require 'data/statements/AddStageToKindStatement'
CreateStatement         = require 'data/statements/CreateStatement'
BulkCreateStatement     = require 'data/statements/BulkCreateStatement'
Command                 = require 'domain/framework/Command'

class CreateStageCommand extends Command

  constructor: (@user, @stage, @position, @checklists) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@stage)
    conn.execute statement, (err, stage) =>
      return callback(err) if err?
      statement = new AddStageToKindStatement(@stage.kind, @stage.id, @position)
      conn.execute statement, (err) =>
        return callback(err) if err?
        statement = new BulkCreateStatement(Checklist, @checklists)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, stage)

module.exports = CreateStageCommand
