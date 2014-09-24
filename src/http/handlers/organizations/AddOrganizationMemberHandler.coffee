Handler = require '../../framework/Handler'

class AddOrganizationMemberHandler extends Handler

  @route 'post /organizations/{organizationId}/users'
  @demand 'is organization member'

  constructor: (@organizationService, @userService) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {userId}       = request.payload
    @userService.get userId, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      @organizationService.addMember organization, user, (err) =>
        return reply err if err?
        return reply()

module.exports = AddOrganizationMemberHandler
