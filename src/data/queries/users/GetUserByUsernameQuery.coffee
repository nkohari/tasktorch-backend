GetByIndexQuery = require 'data/framework/queries/GetByIndexQuery'
User = require 'data/documents/User'

class GetUserByUsernameQuery extends GetByIndexQuery

  constructor: (username, options) ->
    super(User, {username}, options)

module.exports = GetUserByUsernameQuery
