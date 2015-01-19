r                             = require 'rethinkdb'
Command                       = require 'domain/Command'
CommandResult                 = require 'domain/CommandResult'
Move                          = require 'domain/documents/Move'
RemoveActionFromCardStatement = require 'data/statements/RemoveActionFromCardStatement'
AddActionToCardStatement      = require 'data/statements/AddActionToCardStatement'
UpdateActionStatement         = require 'data/statements/UpdateActionStatement'

class MoveActionCommand extends Command

  constructor: (@user, @actionId, @cardId, @stageId, @position = 'append') ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new RemoveActionFromCardStatement(@actionId)
    conn.execute statement, (err, previousCards) =>
      return callback(err) if err?
      statement = new AddActionToCardStatement(@actionId, @cardId, @stageId, @position)
      conn.execute statement, (err, currentCard) =>
        return callback(err) if err?
        result.messages.changed(currentCard)
        for previousCard in previousCards
          result.messages.changed(previousCard) unless previousCard.id == currentCard.id
        statement = new UpdateActionStatement(@actionId, {card: @cardId})
        conn.execute statement, (err, action) =>
          return callback(err) if err?
          result.messages.changed(action)
          result.action = action
          callback(null, result)

module.exports = MoveActionCommand
