Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateOrgCommand extends Command

  constructor: (@user, @org) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@org)
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = CreateOrgCommand
