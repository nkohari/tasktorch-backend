_        = require 'lodash'
Handler  = require 'http/framework/Handler'
Response = require 'http/framework/Response'
GetAllStacksByOrganizationAndUserQuery = require 'data/queries/GetAllStacksByOrganizationAndUserQuery'

class ListMyStacksHandler extends Handler

  @route 'get /api/{organizationId}/me/stacks'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    query = new GetAllStacksByOrganizationAndUserQuery(organization.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMyStacksHandler