async                               = require 'async'
r                                   = require 'rethinkdb'
Command                             = require 'domain/framework/Command'
Action                              = require 'data/documents/Action'
ActionMovedNote                     = require 'data/documents/notes/ActionMovedNote'
AddActionToChecklistStatement       = require 'data/statements/AddActionToChecklistStatement'
CreateStatement                     = require 'data/statements/CreateStatement'
RemoveActionFromChecklistsStatement = require 'data/statements/RemoveActionFromChecklistsStatement'
UpdateCardStagesAndStatusStatement  = require 'data/statements/UpdateCardStagesAndStatusStatement'
UpdateStatement                     = require 'data/statements/UpdateStatement'

class MoveActionCommand extends Command

  constructor: (@user, @action, @checklistid, @cardid, @stageid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveActionFromChecklistsStatement(@action.id)
    conn.execute statement, (err) =>
      return callback(err) if err?
      statement = new AddActionToChecklistStatement(@checklistid, @action.id, @position)
      conn.execute statement, (err) =>
        return callback(err) if err?
        statement = new UpdateStatement(Action, @action.id, {
          card:      @cardid
          checklist: @checklistid
          stage:     @stageid
        })
        conn.execute statement, (err, action, previous) =>
          return callback(err) if err?
          @updateCardStatus conn, action.card, previous.card, (err) =>
            return callback(err) if err?
            note = ActionMovedNote.create(@user, action, previous)
            statement = new CreateStatement(note)
            conn.execute statement, (err) =>
              return callback(err) if err?
              callback(null, action)

  updateCardStatus: (conn, currentid, previousid, callback) ->
    statement = new UpdateCardStagesAndStatusStatement(currentid)
    conn.execute statement, (err) =>
      return callback(err) if err?
      return callback() if currentid == previousid
      statement = new UpdateCardStagesAndStatusStatement(previousid)
      conn.execute statement, callback

module.exports = MoveActionCommand
