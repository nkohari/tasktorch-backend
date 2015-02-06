Command                          = require 'domain/framework/Command'
CreateStatement                  = require 'data/statements/CreateStatement'
CreateDefaultUserStacksStatement = require 'data/statements/CreateDefaultUserStacksStatement'

class CreateOrgCommand extends Command

  constructor: (@user, @org) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@org)
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      statement = new CreateDefaultUserStacksStatement(@user.id, @org.id)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, org)

module.exports = CreateOrgCommand
