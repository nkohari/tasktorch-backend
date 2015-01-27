r     = require 'rethinkdb'
Team  = require 'data/schemas/Team'
Query = require 'data/framework/queries/Query'

class GetAllTeamsByOrgAndOwnerQuery extends Query

  constructor: (orgId, userId, options) ->
    super(Team, options)
    @rql = r.table(@schema.table).getAll(userId, {index: 'members'})
      .filter({org: orgId})
      .coerceTo('array')

module.exports = GetAllTeamsByOrgAndOwnerQuery
