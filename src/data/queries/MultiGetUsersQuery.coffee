MultiGetQuery = require 'data/framework/queries/MultiGetQuery'
User          = require 'data/schemas/User'

class MultiGetUsersQuery extends MultiGetQuery

  constructor: (ids, options) ->
    super(User, ids, options)

module.exports = MultiGetUsersQuery
