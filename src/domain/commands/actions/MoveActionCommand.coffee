r                             = require 'rethinkdb'
Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
RemoveActionFromCardStatement = require 'data/statements/RemoveActionFromCardStatement'
AddActionToCardStatement      = require 'data/statements/AddActionToCardStatement'
UpdateActionStatement         = require 'data/statements/UpdateActionStatement'
ActionMovedNote               = require 'domain/documents/notes/ActionMovedNote'

# TODO: This allows for movement from multiple previous cards. This is only
# to allow the data to self-heal in the case of multiple simultaneous
# modifications; the only sound state for an action is to exist in a single card.

class MoveActionCommand extends Command

  constructor: (@user, @actionid, @cardid, @stageid, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveActionFromCardStatement(@actionid)
    conn.execute statement, (err, previousCards) =>
      return callback(err) if err?
      statement = new AddActionToCardStatement(@actionid, @cardid, @stageid, @position)
      conn.execute statement, (err, currentCard) =>
        return callback(err) if err?
        result.messages.changed(currentCard)
        for previousCard in previousCards
          result.messages.changed(previousCard) unless previousCard.id == currentCard.id
        statement = new UpdateActionStatement(@actionid, {
          card:  @cardid
          stage: @stageid
        })
        conn.execute statement, (err, action, previous) =>
          return callback(err) if err?
          result.messages.changed(action)
          result.addNote(new ActionMovedNote(@user, action, previous))
          result.action = action
          callback(null, result)

module.exports = MoveActionCommand
