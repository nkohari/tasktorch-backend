Handler              = require 'http/framework/Handler'
Response             = require 'http/framework/Response'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'

class GetOrganizationHandler extends Handler

  @route 'get /api/{organizationId}'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organizationId} = request.params
    query = new GetOrganizationQuery(organizationId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetOrganizationHandler
