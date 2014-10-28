UserModel = require 'http/models/UserModel'
Handler = require 'http/framework/Handler'
GetUserQuery = require 'data/queries/GetUserQuery'

class GetUserHandler extends Handler

  @route 'get /api/users/{userId}'
  @demand 'requester is user'

  constructor: (@database) ->

  handle: (request, reply) ->
    {userId} = request.params
    query = new GetUserQuery(userId, @getQueryOptions(request))
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      reply new UserModel(user, request)

module.exports = GetUserHandler
