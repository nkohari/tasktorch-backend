r               = require 'rethinkdb'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class AddLeaderToOrgStatement extends UpdateStatement

  constructor: (orgid, userid) ->
    patch = {
      leaders: r.row('leaders').setInsert(userid)
      members: r.row('members').setInsert(userid)
    }
    super(Org, orgid, patch)

module.exports = AddLeaderToOrgStatement
