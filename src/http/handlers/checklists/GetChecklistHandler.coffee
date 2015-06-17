Handler           = require 'http/framework/Handler'
GetChecklistQuery = require 'data/queries/checklists/GetChecklistQuery'

class GetChecklistHandler extends Handler

  @route 'get /{orgid}/checklists/{checklistid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {checklistid}  = request.params

    query = new GetChecklistQuery(checklistid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.checklist?
      return reply @error.notFound() unless result.checklist.org == org.id
      reply @response(result)

module.exports = GetChecklistHandler
