GetQuery = require 'data/framework/queries/GetQuery'
User     = require 'data/documents/User'

class GetUserQuery extends GetQuery

  constructor: (id, options) ->
    super(User, id, options)

module.exports = GetUserQuery
