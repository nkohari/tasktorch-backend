Handler        = require 'apps/api/framework/Handler'
GetActionQuery = require 'data/queries/actions/GetActionQuery'

class GetActionHandler extends Handler

  @route 'get /{orgid}/actions/{actionid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {actionid}     = request.params

    query = new GetActionQuery(actionid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.action?
      return reply @error.notFound() unless result.action.org == org.id
      reply @response(result)

module.exports = GetActionHandler
