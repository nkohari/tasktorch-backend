Handler = require '../../framework/Handler'

class RemoveOrganizationMemberHandler extends Handler

  @route 'delete /organizations/{organizationId}/users/{userId}'
  @demand 'is organization member'
  
  constructor: (@organizationService, @userService) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {userId}       = request.params
    @userService.get userId, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      @organizationService.removeMember organization, user, (err) =>
        return reply err if err?
        return reply()

module.exports = RemoveOrganizationMemberHandler
