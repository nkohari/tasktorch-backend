Command               = require 'domain/framework/Command'
Card                  = require 'data/documents/Card'
CardEffortChangedNote = require 'data/documents/notes/CardEffortChangedNote'
CreateStatement       = require 'data/statements/CreateStatement'
UpdateStatement       = require 'data/statements/UpdateStatement'

class ChangeCardEffortCommand extends Command

  constructor: (@user, @cardid, @total, @remaining) ->
    super()

  execute: (conn, callback) ->

    effort = {
      total:     @total     if @total?
      remaining: @remaining if @remaining?
    }

    statement = new UpdateStatement(Card, @cardid, {effort})
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = CardEffortChangedNote.create(@user, card, previous)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = ChangeCardEffortCommand
