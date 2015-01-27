r     = require 'rethinkdb'
Team  = require 'data/schemas/Team'
Query = require 'data/framework/queries/Query'

class GetAllTeamsByOrgQuery extends Query

  constructor: (orgId, options) ->
    super(Team, options)
    @rql = r.table(@schema.table).getAll(orgId, {index: 'org'})

module.exports = GetAllTeamsByOrgQuery
