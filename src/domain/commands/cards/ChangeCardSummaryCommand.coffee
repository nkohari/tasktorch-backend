Command                = require 'domain/framework/Command'
CommandResult          = require 'domain/framework/CommandResult'
CardSummaryChangedNote = require 'data/documents/notes/CardSummaryChangedNote'
UpdateCardStatement    = require 'data/statements/UpdateCardStatement'

class ChangeCardSummaryCommand extends Command

  constructor: (@user, @cardid, @summary) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateCardStatement(@cardid, {summary: @summary})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      result.messages.changed(card)
      result.addNote(CardSummaryChangedNote.create(@user, card, previous))
      result.card = card
      callback(null, result)

module.exports = ChangeCardSummaryCommand
