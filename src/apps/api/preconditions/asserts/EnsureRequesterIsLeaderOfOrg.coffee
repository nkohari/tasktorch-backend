_                              = require 'lodash'
Precondition                   = require 'apps/api/framework/Precondition'
MembershipLevel                = require 'data/enums/MembershipLevel'
GetMembershipByOrgAndUserQuery = require 'data/queries/memberships/GetMembershipByOrgAndUserQuery'

class EnsureRequesterIsLeaderOfOrg extends Precondition

  constructor: (@database) ->

  execute: (request, reply) ->
    {org}  = request.pre
    {user} = request.auth.credentials
    query = new GetMembershipByOrgAndUserQuery(org.id, user.id)
    @database.execute query, (err, result) =>
      return reply err if err?
      {membership} = result
      if membership?.level == MembershipLevel.Leader
        return reply()
      else
        return reply @error.forbidden("You are not a leader of org #{org.id}")

module.exports = EnsureRequesterIsLeaderOfOrg
