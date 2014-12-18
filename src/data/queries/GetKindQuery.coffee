GetQuery = require 'data/framework/queries/GetQuery'
Kind     = require 'data/schemas/Kind'

class GetKindQuery extends GetQuery

  constructor: (id, options) ->
    super(Kind, id, options)

module.exports = GetKindQuery
