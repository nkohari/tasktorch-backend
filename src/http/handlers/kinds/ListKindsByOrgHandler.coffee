_                     = require 'lodash'
Handler               = require 'http/framework/Handler'
Response              = require 'http/framework/Response'
GetAllKindsByOrgQuery = require 'data/queries/GetAllKindsByOrgQuery'

class ListKindsByOrgHandler extends Handler

  @route 'get /api/{orgId}/kinds'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {org} = request.scope
    query = new GetAllKindsByOrgQuery(org.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListKindsByOrgHandler
