GetQuery = require 'data/framework/queries/GetQuery'
Stack    = require 'data/schemas/Stack'

class GetStackQuery extends GetQuery

  constructor: (id, options) ->
    super(Stack, id, options)

module.exports = GetStackQuery
