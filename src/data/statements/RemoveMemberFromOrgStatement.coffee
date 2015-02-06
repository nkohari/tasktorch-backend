r               = require 'rethinkdb'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class RemoveMemberFromOrgStatement extends UpdateStatement

  constructor: (orgid, userid) ->
    patch = {
      leaders: r.row('leaders').setDifference([userid])
      members: r.row('members').setDifference([userid])
    }
    super(Org, orgid, patch)

module.exports = RemoveMemberFromOrgStatement
