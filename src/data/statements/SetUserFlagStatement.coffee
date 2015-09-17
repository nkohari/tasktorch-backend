r               = require 'rethinkdb'
User            = require 'data/documents/User'
UpdateStatement = require 'data/statements/UpdateStatement'

class SetUserFlagStatement extends UpdateStatement

  constructor: (userid, flag, value) ->

    if value == true
      flags = r.row('flags').setInsert(flag)
    else
      flags = r.row('flags').setDifference([flag])

    super(User, userid, {flags})

module.exports = SetUserFlagStatement
