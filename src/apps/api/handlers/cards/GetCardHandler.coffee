Handler      = require 'apps/api/framework/Handler'
GetCardQuery = require 'data/queries/cards/GetCardQuery'

class GetCardHandler extends Handler

  @route 'get /{orgid}/cards/{cardid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {cardid}       = request.params

    query = new GetCardQuery(cardid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.card?
      return reply @error.notFound() unless result.card.org == org.id
      reply @response(result)

module.exports = GetCardHandler
