Handler                           = require 'http/framework/Handler'
Response                          = require 'http/framework/Response'
SuggestMembersOfOrganizationQuery = require 'data/queries/SuggestMembersOfOrganizationQuery'
GetAllMembersOfOrganizationQuery  = require 'data/queries/GetAllMembersOfOrganizationQuery'

class ListMembersOfOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/members'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->
    
    {organization} = request.scope
    options        = @getQueryOptions(request)

    if request.query.suggest?
      query = new SuggestMembersOfOrganizationQuery(organization.id, request.query.suggest, options)
    else
      query = new GetAllMembersOfOrganizationQuery(organization.id, options)

    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMembersOfOrganizationHandler
