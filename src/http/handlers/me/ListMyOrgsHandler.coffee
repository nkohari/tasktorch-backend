_                       = require 'lodash'
Handler                 = require 'http/framework/Handler'
Response                = require 'http/framework/Response'
GetAllOrgsByMemberQuery = require 'data/queries/GetAllOrgsByMemberQuery'

class ListMyOrgsHandler extends Handler

  @route 'get /api/me/orgs'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    query = new GetAllOrgsByMemberQuery(user.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMyOrgsHandler
