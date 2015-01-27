Command              = require 'domain/Command'
CommandResult        = require 'domain/CommandResult'
CardTitleChangedNote = require 'domain/documents/notes/CardTitleChangedNote'
UpdateCardStatement  = require 'data/statements/UpdateCardStatement'

class ChangeCardTitleCommand extends Command

  constructor: (@user, @cardId, @title) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateCardStatement(@cardId, {title: @title})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      result.messages.changed(card)
      result.addNote(new CardTitleChangedNote(@user, card, previous))
      result.card = card
      callback(null, result)

module.exports = ChangeCardTitleCommand
