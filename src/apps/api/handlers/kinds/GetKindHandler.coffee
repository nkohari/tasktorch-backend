Handler      = require 'apps/api/framework/Handler'
GetKindQuery = require 'data/queries/kinds/GetKindQuery'

class GetKindHandler extends Handler

  @route 'get /{orgid}/kinds/{kindid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {kindid}       = request.params

    query = new GetKindQuery(kindid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.kind?
      return reply @error.notFound() unless result.kind.org == org.id or not result.kind.org?
      reply @response(result)

module.exports = GetKindHandler
