Handler                       = require 'http/framework/Handler'
GetAllActionsByChecklistQuery = require 'data/queries/actions/GetAllActionsByChecklistQuery'

class ListActionsByChecklistHandler extends Handler

  @route 'get /api/{orgid}/checklists/{checklistid}/actions'

  @before [
    'resolve org'
    'resolve checklist'
    'resolve query options'
    'ensure checklist belongs to org'
    'ensure requester can access checklist'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {checklist, options} = request.pre
    query = new GetAllActionsByChecklistQuery(checklist.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListActionsByChecklistHandler
