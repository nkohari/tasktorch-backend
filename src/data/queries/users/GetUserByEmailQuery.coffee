GetByIndexQuery = require 'data/framework/queries/GetByIndexQuery'
User = require 'data/documents/User'

class GetUserByEmailQuery extends GetByIndexQuery

  constructor: (email, options) ->
    super(User, {email}, options)

module.exports = GetUserByEmailQuery
