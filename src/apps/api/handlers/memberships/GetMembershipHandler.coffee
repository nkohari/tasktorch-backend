Handler            = require 'apps/api/framework/Handler'
GetMembershipQuery = require 'data/queries/memberships/GetMembershipQuery'

class GetMembershipHandler extends Handler

  @route 'get /{orgid}/memberships/{membershipid}'

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    
    {org, options} = request.pre
    {membershipid} = request.params

    query = new GetMembershipQuery(membershipid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.membership?.org == org.id
      reply @response(result)

module.exports = GetMembershipHandler
