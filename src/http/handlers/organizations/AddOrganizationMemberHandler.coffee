{User}     = require 'data/entities'
{GetQuery} = require 'data/queries'
Handler    = require '../../framework/Handler'

class AddOrganizationMemberHandler extends Handler

  @route 'post /api/{organizationId}/users'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {userId}       = request.payload

    query = new GetQuery(User, userId)
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      organization.addMember(user)
      @database.update organization, (err) =>
        return reply err if err?
        return reply()

module.exports = AddOrganizationMemberHandler
