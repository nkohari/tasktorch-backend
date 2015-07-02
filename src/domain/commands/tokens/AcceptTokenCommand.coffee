Command         = require 'domain/framework/Command'
Token           = require 'data/documents/Token'
TokenStatus     = require 'data/enums/InviteStatus'
UpdateStatement = require 'data/statements/UpdateStatement'

class AcceptTokenCommand extends Command

  constructor: (@requester, @user, @token) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Token, @token.id, {status: TokenStatus.Accepted})
    conn.execute statement, (err, token) =>
      return callback(err) if err?
      callback(null, token)

module.exports = AcceptTokenCommand
