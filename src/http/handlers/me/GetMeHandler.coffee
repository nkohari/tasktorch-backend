GetUserQuery = require 'data/queries/GetUserQuery'
Handler      = require 'http/framework/Handler'
Response     = require 'http/framework/Response'

class GetMeHandler extends Handler

  @route 'get /api/me'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    query = new GetUserQuery(user.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetMeHandler
