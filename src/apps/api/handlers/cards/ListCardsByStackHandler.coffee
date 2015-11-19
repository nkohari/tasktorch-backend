Handler                 = require 'apps/api/framework/Handler'
GetAllCardsByStackQuery = require 'data/queries/cards/GetAllCardsByStackQuery'

class ListCardsByStackHandler extends Handler

  @route 'get /{orgid}/stacks/{stackid}/cards'

  @before [
    'resolve org'
    'resolve stack'
    'resolve query options'
    'ensure org has active subscription'
    'ensure stack belongs to org'
    'ensure requester can access stack'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {stack, options} = request.pre
    query = new GetAllCardsByStackQuery(stack.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListCardsByStackHandler
