r     = require 'rethinkdb'
Team  = require 'data/schemas/Team'
Query = require 'data/framework/queries/Query'

class SuggestTeamsByOrganizationQuery extends Query

  constructor: (organizationId, phrase, options) ->
    super(Team, options)
    expression = "(?i)^#{phrase}"
    @rql = r.table(Team.table).getAll(organizationId, {index: 'organization'})
      .filter (team) -> team('name').match(expression)
      .coerceTo('array')

module.exports = SuggestTeamsByOrganizationQuery
