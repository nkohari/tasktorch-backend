Handler     = require 'http/framework/Handler'
Response    = require 'http/framework/Response'
GetOrgQuery = require 'data/queries/GetOrgQuery'

class GetOrgHandler extends Handler

  @route 'get /api/{orgId}'
  @demand 'requester is org member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {orgId} = request.params
    query = new GetOrgQuery(orgId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetOrgHandler
