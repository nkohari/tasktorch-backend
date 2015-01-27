Command                = require 'domain/Command'
CommandResult          = require 'domain/CommandResult'
CardSummaryChangedNote = require 'domain/documents/notes/CardSummaryChangedNote'
UpdateCardStatement    = require 'data/statements/UpdateCardStatement'

class ChangeCardSummaryCommand extends Command

  constructor: (@user, @cardId, @summary) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateCardStatement(@cardId, {summary: @summary})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      result.messages.changed(card)
      result.addNote(new CardSummaryChangedNote(@user, card, previous))
      result.card = card
      callback(null, result)

module.exports = ChangeCardSummaryCommand
