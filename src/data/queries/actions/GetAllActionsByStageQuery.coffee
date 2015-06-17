GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Action             = require 'data/documents/Action'

class GetAllActionsByStageQuery extends GetAllByIndexQuery

  constructor: (stageid, options) ->
    super(Action, {stage: stageid}, options)

module.exports = GetAllActionsByStageQuery
