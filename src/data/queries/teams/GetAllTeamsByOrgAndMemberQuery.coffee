r     = require 'rethinkdb'
Team  = require 'data/schemas/Team'
Query = require 'data/framework/queries/Query'

class GetAllTeamsByOrgAndOwnerQuery extends Query

  constructor: (orgid, userid, options) ->
    super(Team, options)
    @rql = r.table(@schema.table).getAll(userid, {index: 'members'})
      .filter({org: orgid})
      .coerceTo('array')

module.exports = GetAllTeamsByOrgAndOwnerQuery
