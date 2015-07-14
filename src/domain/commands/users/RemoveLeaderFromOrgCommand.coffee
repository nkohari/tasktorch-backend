r               = require 'rethinkdb'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'
Command         = require 'domain/framework/Command'

class RemoveLeaderFromOrgCommand extends Command

  constructor: (@requester, @org, @user) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Org, @org.id, {
      leaders: r.row('leaders').setDifference([@user.id])
    })
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = RemoveLeaderFromOrgCommand
