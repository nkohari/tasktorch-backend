Handler                  = require 'http/framework/Handler'
Response                 = require 'http/framework/Response'
SuggestMembersByOrgQuery = require 'data/queries/SuggestMembersByOrgQuery'
GetAllMembersByOrgQuery  = require 'data/queries/GetAllMembersByOrgQuery'

class ListMembersByOrgHandler extends Handler

  @route 'get /api/{orgId}/members'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    
    {org} = request.scope
    options = @getQueryOptions(request)

    if request.query.suggest?
      query = new SuggestMembersByOrgQuery(org.id, request.query.suggest, options)
    else
      query = new GetAllMembersByOrgQuery(org.id, options)

    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMembersByOrgHandler
