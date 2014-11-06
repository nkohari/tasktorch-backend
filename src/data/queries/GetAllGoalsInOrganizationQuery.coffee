r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Goal  = require 'data/schemas/Goal'

class GetAllGoalsInOrganizationQuery extends Query

  constructor: (organizationId, options) ->
    super(Goal, options)
    @rql = r.table(Goal.table).getAll(organizationId, {index: 'organization'})

module.exports = GetAllGoalsInOrganizationQuery
