Command                = require 'domain/framework/Command'
Org                    = require 'data/documents/Org'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class ChangeAccountSourceCommand extends Command

  constructor: (@accountid, @source) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Org, {account: @accountid}, {account: {@source}})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeAccountSourceCommand
