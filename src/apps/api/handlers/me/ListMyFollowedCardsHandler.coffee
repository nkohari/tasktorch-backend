Handler                    = require 'apps/api/framework/Handler'
GetAllCardsByFollowerQuery = require 'data/queries/cards/GetAllCardsByFollowerQuery'

class ListMyFollowedCardsHandler extends Handler

  @route 'get /{orgid}/me/following'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {user}         = request.auth.credentials

    query = new GetAllCardsByFollowerQuery(org.id, user.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListMyFollowedCardsHandler
