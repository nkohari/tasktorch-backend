Handler                    = require 'apps/api/framework/Handler'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'

class GetQueueByUserHandler extends Handler

  @route 'get /{orgid}/users/{userid}/queue'

  @before [
    'resolve org'
    'resolve user'
    'resolve query options'
    'ensure org has active subscription'
    'ensure user is member of org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, user, options} = request.pre

    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Queue, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.stack?
      reply @response(result)

module.exports = GetQueueByUserHandler
