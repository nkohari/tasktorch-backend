Command                         = require 'domain/framework/Command'
Card                            = require 'data/documents/Card'
FollowerRemovedNote             = require 'data/documents/notes/FollowerRemovedNote'
CreateStatement                 = require 'data/statements/CreateStatement'
RemoveFollowerFromCardStatement = require 'data/statements/RemoveFollowerFromCardStatement'

class RemoveFollowerFromCardCommand extends Command

  constructor: (@user, @card, @follower) ->
    super()

  execute: (conn, callback) ->
    statement = new RemoveFollowerFromCardStatement(@card.id, @follower.id)
    conn.execute statement, (err, card, previous) =>
      return callback(err) if err?
      note = FollowerRemovedNote.create(@user, card, @follower)
      statement = new CreateStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, card)

module.exports = RemoveFollowerFromCardCommand
