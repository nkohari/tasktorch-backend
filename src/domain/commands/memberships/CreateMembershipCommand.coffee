Command                          = require 'domain/framework/Command'
CreateStatement                  = require 'data/statements/CreateStatement'
CreateUserProfileStatement       = require 'data/statements/CreateUserProfileStatement'
CreateDefaultUserStacksStatement = require 'data/statements/CreateDefaultUserStacksStatement'

class CreateMembershipCommand extends Command

  constructor: (@user, @membership) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@membership)
    conn.execute statement, (err, membership) =>
      return callback(err) if err?
      statement = new CreateDefaultUserStacksStatement(@membership.user, @membership.org)
      conn.execute statement, (err) =>
        return callback(err) if err?
        statement = new CreateUserProfileStatement(@membership.user, @membership.org)
        conn.execute statement, (err) =>
          return callback(err) if err?
          return callback(null, membership)

module.exports = CreateMembershipCommand
