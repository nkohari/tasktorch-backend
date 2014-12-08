_         = require 'lodash'
Handler   = require 'http/framework/Handler'
Response  = require 'http/framework/Response'
StackType = require 'data/enums/StackType'
GetSpecialStackByOrganizationAndUserQuery = require 'data/queries/GetSpecialStackByOrganizationAndUserQuery'

class GetMyQueueHandler extends Handler

  @route 'get /api/{organizationId}/me/queue'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user}         = request.auth.credentials
    {organization} = request.scope
    query = new GetSpecialStackByOrganizationAndUserQuery(organization.id, user.id, StackType.Queue, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetMyQueueHandler
