User     = require 'data/entities/User'
GetQuery = require 'data/queries/GetQuery'
Handler  = require '../../framework/Handler'

class AddOrganizationMemberHandler extends Handler

  @route 'post /organizations/{organizationId}/users'
  @demand 'is organization member'

  constructor: (@database, @organizationService) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {userId}       = request.payload

    query = new GetQuery(User, userId)
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      @organizationService.addMember organization, user, (err) =>
        return reply err if err?
        return reply()

module.exports = AddOrganizationMemberHandler
