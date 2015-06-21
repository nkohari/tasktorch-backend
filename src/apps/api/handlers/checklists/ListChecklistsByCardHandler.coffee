Handler                     = require 'apps/api/framework/Handler'
GetAllChecklistsByCardQuery = require 'data/queries/checklists/GetAllChecklistsByCardQuery'

class ListChecklistsByCardHandler extends Handler

  @route 'get /{orgid}/cards/{cardid}/checklists'

  @before [
    'resolve org'
    'resolve card'
    'resolve query options'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {card, options} = request.pre
    query = new GetAllChecklistsByCardQuery(card.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListChecklistsByCardHandler
