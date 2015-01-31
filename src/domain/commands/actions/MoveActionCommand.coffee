r                             = require 'rethinkdb'
Command                       = require 'domain/framework/Command'
ActionMovedNote               = require 'data/documents/notes/ActionMovedNote'
RemoveActionFromCardStatement = require 'data/statements/RemoveActionFromCardStatement'
AddActionToCardStatement      = require 'data/statements/AddActionToCardStatement'
UpdateActionStatement         = require 'data/statements/UpdateActionStatement'
CreateNoteStatement           = require 'data/statements/CreateNoteStatement'

# TODO: This allows for movement from multiple previous cards. This is only
# to allow the data to self-heal in the case of multiple simultaneous
# modifications; the only sound state for an action is to exist in a single card.

class MoveActionCommand extends Command

  constructor: (@user, @actionid, @cardid, @stageid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveActionFromCardStatement(@actionid)
    conn.execute statement, (err, previousCards) =>
      return callback(err) if err?
      statement = new AddActionToCardStatement(@actionid, @cardid, @stageid, @position)
      conn.execute statement, (err, currentCard) =>
        return callback(err) if err?
        statement = new UpdateActionStatement(@actionid, {
          card:  @cardid
          stage: @stageid
        })
        conn.execute statement, (err, action, previous) =>
          return callback(err) if err?
          note = ActionMovedNote.create(@user, action, previous)
          statement = new CreateNoteStatement(note)
          conn.execute statement, (err) =>
            return callback(err) if err?
            callback(null, action)

module.exports = MoveActionCommand
