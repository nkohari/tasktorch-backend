_                              = require 'lodash'
Handler                        = require 'http/framework/Handler'
Response                       = require 'http/framework/Response'
GetAllKindsByOrganizationQuery = require 'data/queries/GetAllKindsByOrganizationQuery'

class ListKindsInOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/kinds'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    query = new GetAllKindsByOrganizationQuery(organization.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListKindsInOrganizationHandler
