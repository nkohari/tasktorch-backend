Handler = require 'http/framework/Handler'
GetUserQuery = require 'data/queries/GetUserQuery'

class GetUserHandler extends Handler

  @route 'get /api/users/{userId}'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {userId} = request.params
    query = new GetUserQuery(userId, @getQueryOptions(request))
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      model = @modelFactory.create(user, request)
      reply(model).etag(model.version)

module.exports = GetUserHandler
