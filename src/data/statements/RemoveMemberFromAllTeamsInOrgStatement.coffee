r                   = require 'rethinkdb'
Team                = require 'data/documents/Team'
BulkUpdateStatement = require 'data/statements/BulkUpdateStatement'

class RemoveMemberFromAllTeamsInOrgStatement extends BulkUpdateStatement

  constructor: (orgid, userid) ->
    match = r.table(Team.getSchema().table).getAll(orgid, {index: 'org'})
    patch = {
      leaders: r.row('leaders').setDifference([userid])
      members: r.row('members').setDifference([userid])
    }
    super(Team, match, patch)

module.exports = RemoveMemberFromAllTeamsInOrgStatement
