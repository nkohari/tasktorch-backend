GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Goal               = require 'data/schemas/Goal'

class GetAllGoalsByOrganizationQuery extends GetAllByIndexQuery

  constructor: (organizationId, options) ->
    super(Goal, {organization: organizationId}, options)

module.exports = GetAllGoalsByOrganizationQuery
