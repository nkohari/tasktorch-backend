Command                                  = require 'domain/framework/Command'
Checklist                                = require 'data/documents/Checklist'
Stage                                    = require 'data/documents/Stage'
DocumentStatus                           = require 'data/enums/DocumentStatus'
MoveAllActionsBetweenChecklistsStatement = require 'data/statements/MoveAllActionsBetweenChecklistsStatement'
MoveAllActionsToAnotherStageStatement    = require 'data/statements/MoveAllActionsToAnotherStageStatement'
DeleteAllChecklistsByStageStatement      = require 'data/statements/DeleteAllChecklistsByStageStatement'
RemoveStageFromKindStatement             = require 'data/statements/RemoveStageFromKindStatement'
UpdateStatement                          = require 'data/statements/UpdateStatement'

class DeleteStageCommand extends Command

  constructor: (@user, @stage, @inheritorStage) ->

  execute: (conn, callback) ->
    statement = new MoveAllActionsBetweenChecklistsStatement(@stage.id, @inheritorStage.id)
    conn.execute statement, (err) =>
      return callback(err) if err?
      statement = new MoveAllActionsToAnotherStageStatement(@stage.id, @inheritorStage.id)
      conn.execute statement, (err) =>
        return callback(err) if err?
        statement = new DeleteAllChecklistsByStageStatement(@stage.id)
        conn.execute statement, (err) =>
          return callback(err) if err?
          statement = new RemoveStageFromKindStatement(@stage.kind, @stage.id)
          conn.execute statement, (err) =>
            return callback(err) if err?
            statement = new UpdateStatement(Stage, @stage.id, {status: DocumentStatus.Deleted})
            conn.execute statement, (err, stage) =>
              return callback(err) if err?
              callback(null, stage)

module.exports = DeleteStageCommand
