GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Goal               = require 'data/schemas/Goal'

class GetAllGoalsByOrgQuery extends GetAllByIndexQuery

  constructor: (orgId, options) ->
    super(Goal, {org: orgId}, options)

module.exports = GetAllGoalsByOrgQuery
