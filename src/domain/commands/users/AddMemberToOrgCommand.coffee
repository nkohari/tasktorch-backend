Command                   = require 'domain/framework/Command'
Stack                     = require 'data/documents/Stack'
StackType                 = require 'data/enums/StackType'
BulkCreateStacksStatement = require 'data/statements/BulkCreateStacksStatement'
AddMemberToOrgStatement   = require 'data/statements/AddMemberToOrgStatement'

class AddMemberToOrgCommand extends Command

  constructor: (@requester, @user, @org) ->

  execute: (conn, callback) ->
    statement = new BulkCreateStacksStatement([
      new Stack { org: @org.id, user: @user.id, type: StackType.Inbox  }
      new Stack { org: @org.id, user: @user.id, type: StackType.Queue  }
      new Stack { org: @org.id, user: @user.id, type: StackType.Drafts }
    ])
    conn.execute statement, (err) =>
      return callback(err) if err?
      statement = new AddMemberToOrgStatement(@org.id, @user.id)
      conn.execute statement, (err, org) =>
        return callback(err) if err?
        callback(null, org)

module.exports = AddMemberToOrgCommand
