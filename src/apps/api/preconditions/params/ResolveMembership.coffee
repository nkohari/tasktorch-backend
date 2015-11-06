Precondition       = require 'apps/api/framework/Precondition'
GetMembershipQuery = require 'data/queries/memberships/GetMembershipQuery'

class ResolveMembership extends Precondition

  assign: 'membership'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetMembershipQuery(request.params.membershipid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.membership?
      reply(result.membership)

module.exports = ResolveMembership
