_                               = require 'lodash'
Handler                         = require 'http/framework/Handler'
Response                        = require 'http/framework/Response'
SuggestTeamsByOrganizationQuery = require 'data/queries/SuggestTeamsByOrganizationQuery'
GetAllTeamsByOrganizationQuery  = require 'data/queries/GetAllTeamsByOrganizationQuery'

class ListTeamsByOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/teams'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    options = @getQueryOptions(request)

    if request.query.suggest?
      query = new SuggestTeamsByOrganizationQuery(organization.id, request.query.suggest, options)
    else
      query = new GetAllTeamsByOrganizationQuery(organization.id, options)

    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListTeamsByOrganizationHandler
