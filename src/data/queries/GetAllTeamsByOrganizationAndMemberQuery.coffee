r     = require 'rethinkdb'
Team  = require 'data/schemas/Team'
Query = require 'data/framework/queries/Query'

class GetAllTeamsByOrganizationAndOwnerQuery extends Query

  constructor: (organizationId, userId, options) ->
    super(Team, options)
    @rql = r.table(@schema.table).getAll(userId, {index: 'members'})
      .filter({organization: organizationId})

module.exports = GetAllTeamsByOrganizationAndOwnerQuery
