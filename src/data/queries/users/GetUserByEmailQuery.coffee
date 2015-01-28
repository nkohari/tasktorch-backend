GetByIndexQuery = require 'data/framework/queries/GetByIndexQuery'
User = require 'data/schemas/User'

class GetUserByEmailQuery extends GetByIndexQuery

  constructor: (email, options) ->
    super(User, {emails: email}, options)

module.exports = GetUserByEmailQuery
