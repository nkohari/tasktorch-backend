_                          = require 'lodash'
Handler                    = require 'http/framework/Handler'
Response                   = require 'http/framework/Response'
StackType                  = require 'domain/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/GetSpecialStackByUserQuery'

class GetMyQueueHandler extends Handler

  @route 'get /api/{orgId}/me/queue'
  @demand 'requester is org member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    {org}  = request.scope
    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Queue, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetMyQueueHandler
