GetQuery = require 'data/framework/queries/GetQuery'
Action   = require 'data/documents/Action'

class GetActionQuery extends GetQuery

  constructor: (id, options) ->
    super(Action, id, options)

module.exports = GetActionQuery
