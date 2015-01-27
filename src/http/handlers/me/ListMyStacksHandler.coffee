_                             = require 'lodash'
Handler                       = require 'http/framework/Handler'
Response                      = require 'http/framework/Response'
GetAllStacksByOrgAndUserQuery = require 'data/queries/GetAllStacksByOrgAndUserQuery'

class ListMyStacksHandler extends Handler

  @route 'get /api/{orgId}/me/stacks'
  @demand 'requester is org member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {org} = request.scope
    {user} = request.auth.credentials
    query = new GetAllStacksByOrgAndUserQuery(org.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMyStacksHandler
