{User}     = require 'data/entities'
{GetQuery} = require 'data/queries'
Handler    = require '../../framework/Handler'

class RemoveOrganizationMemberHandler extends Handler

  @route 'delete /{organizationId}/users/{userId}'
  @demand 'requester is organization member'
  
  constructor: (@database) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {userId}       = request.payload

    query = new GetQuery(User, userId)
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      organization.removeMember(user)
      @database.update organization, (err) =>
        return reply err if err?
        return reply()

module.exports = RemoveOrganizationMemberHandler
