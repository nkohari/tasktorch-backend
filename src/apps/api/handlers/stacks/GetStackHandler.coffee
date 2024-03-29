Handler       = require 'apps/api/framework/Handler'
GetStackQuery = require 'data/queries/stacks/GetStackQuery'

class GetStackHandler extends Handler

  @route 'get /{orgid}/stacks/{stackid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {stackid}      = request.params

    query = new GetStackQuery(stackid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.stack?.org == org.id
      reply @response(result)

module.exports = GetStackHandler
