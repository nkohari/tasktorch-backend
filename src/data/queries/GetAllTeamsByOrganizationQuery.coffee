r     = require 'rethinkdb'
Team  = require 'data/schemas/Team'
Query = require 'data/framework/queries/Query'

class GetAllTeamsByOrganizationQuery extends Query

  constructor: (organizationId, options) ->
    super(Team, options)
    @rql = r.table(@schema.table).getAll(organizationId, {index: 'organization'})

module.exports = GetAllTeamsByOrganizationQuery
