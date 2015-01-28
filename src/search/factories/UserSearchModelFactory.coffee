GetUserQuery    = require 'data/queries/users/GetUserQuery'
UserSearchModel = require 'search/models/UserSearchModel'

class UserSearchModelFactory

  @handles: 'User'

  constructor: (@database) ->

  create: (id, callback) ->
    query = new GetUserQuery(id)
    @database.execute query, (err, user) =>
      return callback(err) if err?
      return callback() unless user?
      model = new UserSearchModel(user)
      callback(null, model)

module.exports = UserSearchModelFactory
