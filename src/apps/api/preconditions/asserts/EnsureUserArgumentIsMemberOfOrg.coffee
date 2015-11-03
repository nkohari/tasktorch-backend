_                                  = require 'lodash'
Precondition                       = require 'apps/api/framework/Precondition'
GetAllActiveMembershipsByUserQuery = require 'data/queries/memberships/GetAllActiveMembershipsByUserQuery'

class EnsureUserArgumentIsMemberOfOrg extends Precondition

  constructor: (@database) ->

  execute: (request, reply) ->
    {org, user} = request.pre
    return reply() unless user?
    query = new GetAllActiveMembershipsByUserQuery(user.id)
    @database.execute query, (err, result) =>
      return reply err if err?
      if _.any(result.memberships, (m) -> m.org == org.id)
        return reply()
      else
        return reply @error.badRequest("The user #{user.id} is not a member of the org #{org.id}")

module.exports = EnsureUserArgumentIsMemberOfOrg
