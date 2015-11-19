_           = require 'lodash'
Handler     = require 'apps/api/framework/Handler'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'
GetOrgEvent = require 'domain/events/GetOrgEvent'

class GetOrgHandler extends Handler

  @route 'get /{orgid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database, @gatekeeper, @spool) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {user}         = request.auth.credentials

    @spool.write new GetOrgEvent(user.id, org.id)

    # TODO: The preconditions load the org to check its subscription,
    # but we need to load it again to ensure query options are used.
    # Revisit this to avoid the double-query.

    query = new GetOrgQuery(org.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = GetOrgHandler
