GetQuery = require 'data/framework/queries/GetQuery'
Goal     = require 'data/documents/Goal'

class GetGoalQuery extends GetQuery

  constructor: (id, options) ->
    super(Goal, id, options)

module.exports = GetGoalQuery
