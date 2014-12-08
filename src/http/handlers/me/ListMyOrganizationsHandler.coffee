_        = require 'lodash'
Handler  = require 'http/framework/Handler'
Response = require 'http/framework/Response'
GetAllOrganizationsByMemberQuery = require 'data/queries/GetAllOrganizationsByMemberQuery'

class ListMyOrganizationsHandler extends Handler

  @route 'get /api/me/organizations'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    query = new GetAllOrganizationsByMemberQuery(user.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMyOrganizationsHandler
