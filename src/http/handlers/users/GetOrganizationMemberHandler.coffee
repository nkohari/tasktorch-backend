Handler      = require 'http/framework/Handler'
Response     = require 'http/framework/Response'
GetUserQuery = require 'data/queries/GetUserQuery'

class GetOrganizationMemberHandler extends Handler

  @route 'get /api/{organizationId}/members/{userId}'
  @demand ['requester is organization member', 'user is member of organization']

  constructor: (@database) ->

  handle: (request, reply) ->
    {userId} = request.params
    query = new GetUserQuery(userId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetOrganizationMemberHandler
