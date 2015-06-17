Handler       = require 'http/framework/Handler'
GetStageQuery = require 'data/queries/stages/GetStageQuery'

class GetStageHandler extends Handler

  @route 'get /{orgid}/stages/{stageid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure stage belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {stageid}      = request.params

    query = new GetStageQuery(stageid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.stage?
      return reply @error.notFound() unless result.stage.org == org.id
      reply @response(result)

module.exports = GetStageHandler
