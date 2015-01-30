GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Goal               = require 'data/documents/Goal'

class GetAllGoalsByOrgQuery extends GetAllByIndexQuery

  constructor: (orgid, options) ->
    super(Goal, {org: orgid}, options)

module.exports = GetAllGoalsByOrgQuery
