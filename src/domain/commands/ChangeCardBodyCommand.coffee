Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
UpdateCardStatement = require 'data/statements/UpdateCardStatement'

class ChangeCardBodyCommand extends Command

  constructor: (@user, @cardId, @body) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateCardStatement(@cardId, {body: @body})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      result.messages.changed(card)
      result.notes.changed('body', card, previous)
      result.card = card
      callback(null, result)

module.exports = ChangeCardBodyCommand
