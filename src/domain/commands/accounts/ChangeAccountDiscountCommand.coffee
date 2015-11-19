Command                = require 'domain/framework/Command'
Org                    = require 'data/documents/Org'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class ChangeAccountDiscountCommand extends Command

  constructor: (@accountid, @discount) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Org, {account: @accountid}, {account: {@discount}})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeAccountDiscountCommand
