User     = require 'data/entities/User'
GetQuery = require 'data/queries/GetQuery'
Handler  = require '../../framework/Handler'

class RemoveOrganizationMemberHandler extends Handler

  @route 'delete /organizations/{organizationId}/users/{userId}'
  @demand 'is organization member'
  
  constructor: (@database, @organizationService) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {userId}       = request.payload

    query = new GetQuery(User, userId)
    @database.execute query, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      @organizationService.removeMember organization, user, (err) =>
        return reply err if err?
        return reply()

module.exports = RemoveOrganizationMemberHandler
