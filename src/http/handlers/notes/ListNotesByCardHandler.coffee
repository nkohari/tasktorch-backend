Handler                = require 'http/framework/Handler'
GetAllNotesByCardQuery = require 'data/queries/notes/GetAllNotesByCardQuery'

class ListNotesByCardHandler extends Handler

  @route 'get /api/{orgid}/cards/{cardid}/notes'

  @pre [
    'resolve org'
    'resolve card'
    'resolve query options'
    'ensure card belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {card, options} = request.pre
    query = new GetAllNotesByCardQuery(card.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListNotesByCardHandler
