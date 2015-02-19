Command                    = require 'domain/framework/Command'
Card                       = require 'data/documents/Card'
FollowerAddedNote          = require 'data/documents/notes/FollowerAddedNote'
CreateStatement            = require 'data/statements/CreateStatement'
AddFollowerToCardStatement = require 'data/statements/AddFollowerToCardStatement'

class AddFollowerToCardCommand extends Command

  constructor: (@user, @card, @follower) ->
    super()

  execute: (conn, callback) ->
    statement = new AddFollowerToCardStatement(@card.id, @follower.id)
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = FollowerAddedNote.create(@user, card, @follower)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = AddFollowerToCardCommand
