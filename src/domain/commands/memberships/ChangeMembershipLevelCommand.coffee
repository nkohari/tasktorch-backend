Command         = require 'domain/framework/Command'
Membership      = require 'data/documents/Membership'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeMembershipLevelCommand extends Command

  constructor: (@membership, @level) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Membership, @membership.id, {@level})
    conn.execute statement, (err, membership) =>
      return callback(err) if err?
      callback(null, membership)

module.exports = ChangeMembershipLevelCommand
