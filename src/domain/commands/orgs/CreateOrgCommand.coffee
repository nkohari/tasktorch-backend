Command                          = require 'domain/framework/Command'
CreateOrgStatement               = require 'data/statements/CreateOrgStatement'
CreateDefaultUserStacksStatement = require 'data/statements/CreateDefaultUserStacksStatement'

class CreateOrgCommand extends Command

  constructor: (@user, @org) ->

  execute: (conn, callback) ->
    statement = new CreateOrgStatement(@org)
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      statement = new CreateDefaultUserStacksStatement(@user.id, @org.id)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, org)

module.exports = CreateOrgCommand
