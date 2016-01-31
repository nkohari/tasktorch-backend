r               = require 'rethinkdb'
Card            = require 'data/documents/Card'
UpdateStatement = require 'data/statements/UpdateStatement'
Command         = require 'domain/framework/Command'

class AddFileToCardCommand extends Command

  constructor: (@user, @file, @card) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Card, @card.id, {
      files: r.row('files').setInsert(@file.id)
    })
    conn.execute statement, (err, card) =>
      return callback(err) if err?
      callback(null, card)

module.exports = AddFileToCardCommand
