Command             = require 'domain/framework/Command'
BulkCreateStatement = require 'data/statements/BulkCreateStatement'
Token               = require 'data/documents/Token'

class CreateTokensCommand extends Command

  constructor: (@user, @tokens) ->

  execute: (conn, callback) ->
    statement = new BulkCreateStatement(Token, @tokens)
    conn.execute statement, (err, tokens) =>
      return callback(err) if err?
      callback(null, tokens)

module.exports = CreateTokensCommand
