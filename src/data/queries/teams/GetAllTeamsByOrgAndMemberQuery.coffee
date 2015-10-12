r     = require 'rethinkdb'
Team  = require 'data/documents/Team'
Query = require 'data/framework/queries/Query'

class GetAllTeamsByOrgAndMemberQuery extends Query

  constructor: (orgid, userid, options) ->
    super(Team, options)
    @rql = r.table(@schema.table).getAll(userid, {index: 'members'})
      .filter({org: orgid})
      .coerceTo('array')

module.exports = GetAllTeamsByOrgAndMemberQuery
