_           = require 'lodash'
Handler     = require 'apps/api/framework/Handler'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'
GetOrgEvent = require 'domain/events/GetOrgEvent'

class GetOrgHandler extends Handler

  @route 'get /{orgid}'

  @before [
    'resolve query options'
  ]

  constructor: (@database, @gatekeeper, @spool) ->

  handle: (request, reply) ->

    {options} = request.pre
    {orgid}   = request.params
    {user}    = request.auth.credentials

    @spool.write new GetOrgEvent(user.id, orgid)

    query = new GetOrgQuery(orgid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.org?
      @gatekeeper.canUserAccess result.org, user, (err, canAccess) =>
        return reply err if err?
        return reply @error.forbidden() unless canAccess
        reply @response(result)

module.exports = GetOrgHandler
