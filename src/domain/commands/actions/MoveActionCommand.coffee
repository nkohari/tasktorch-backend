async                               = require 'async'
r                                   = require 'rethinkdb'
Command                             = require 'domain/framework/Command'
Action                              = require 'data/documents/Action'
ActionMovedNote                     = require 'data/documents/notes/ActionMovedNote'
AddActionToChecklistStatement       = require 'data/statements/AddActionToChecklistStatement'
CreateStatement                     = require 'data/statements/CreateStatement'
RemoveActionFromChecklistsStatement = require 'data/statements/RemoveActionFromChecklistsStatement'
UpdateStatement                     = require 'data/statements/UpdateStatement'

class MoveActionCommand extends Command

  constructor: (@user, @actionid, @checklistid, @cardid, @stageid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveActionFromChecklistsStatement(@actionid)
    conn.execute statement, (err) =>
      return callback(err) if err?
      statement = new AddActionToChecklistStatement(@checklistid, @actionid, @position)
      conn.execute statement, (err) =>
        return callback(err) if err?
        statement = new UpdateStatement(Action, @actionid, {
          card:      @cardid
          checklist: @checklistid
          stage:     @stageid
        })
        conn.execute statement, (err, action, previous) =>
          return callback(err) if err?
          note = ActionMovedNote.create(@user, action, previous)
          statement = new CreateStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, action)


module.exports = MoveActionCommand
