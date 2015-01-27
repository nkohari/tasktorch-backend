r     = require 'rethinkdb'
Team  = require 'data/schemas/Team'
Query = require 'data/framework/queries/Query'

class SuggestTeamsByOrgQuery extends Query

  constructor: (orgId, phrase, options) ->
    super(Team, options)
    expression = "(?i)^#{phrase}"
    @rql = r.table(Team.table).getAll(orgId, {index: 'org'})
      .filter (team) -> team('name').match(expression)
      .coerceTo('array')

module.exports = SuggestTeamsByOrgQuery
