Command         = require 'domain/framework/Command'
Membership      = require 'data/documents/Membership'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeMembershipStatusCommand extends Command

  constructor: (@membership, @status) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Membership, @membership.id, {@status})
    conn.execute statement, (err, membership) =>
      return callback(err) if err?
      callback(null, membership)

module.exports = ChangeMembershipStatusCommand
