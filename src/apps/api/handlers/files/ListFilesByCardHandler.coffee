Handler                = require 'apps/api/framework/Handler'
GetAllFilesByCardQuery = require 'data/queries/files/GetAllFilesByCardQuery'

class ListFilesByCardHandler extends Handler

  @route 'get /{orgid}/cards/{cardid}/files'

  @before [
    'resolve org'
    'resolve card'
    'resolve query options'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {card, options} = request.pre
    query = new GetAllFilesByCardQuery(card.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListFilesByCardHandler
