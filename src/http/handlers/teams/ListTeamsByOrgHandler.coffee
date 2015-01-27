_                      = require 'lodash'
Handler                = require 'http/framework/Handler'
Response               = require 'http/framework/Response'
SuggestTeamsByOrgQuery = require 'data/queries/SuggestTeamsByOrgQuery'
GetAllTeamsByOrgQuery  = require 'data/queries/GetAllTeamsByOrgQuery'

class ListTeamsByOrgHandler extends Handler

  @route 'get /api/{orgId}/teams'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {org} = request.scope
    options = @getQueryOptions(request)

    if request.query.suggest?
      query = new SuggestTeamsByOrgQuery(org.id, request.query.suggest, options)
    else
      query = new GetAllTeamsByOrgQuery(org.id, options)

    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListTeamsByOrgHandler
