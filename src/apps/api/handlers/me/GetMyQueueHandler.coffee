Handler                    = require 'apps/api/framework/Handler'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'

class GetMyQueueHandler extends Handler

  @route 'get /{orgid}/me/queue'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {user}         = request.auth.credentials

    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Queue, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = GetMyQueueHandler
