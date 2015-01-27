Handler      = require 'http/framework/Handler'
Response     = require 'http/framework/Response'
GetUserQuery = require 'data/queries/GetUserQuery'

class GetOrgMemberHandler extends Handler

  @route 'get /api/{orgId}/members/{userId}'
  @demand ['requester is org member', 'user is member of org']

  constructor: (@database) ->

  handle: (request, reply) ->
    {userId} = request.params
    query = new GetUserQuery(userId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetOrgMemberHandler
