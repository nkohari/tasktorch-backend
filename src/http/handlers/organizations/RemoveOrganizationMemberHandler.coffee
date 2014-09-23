Handler = require '../../framework/Handler'

class RemoveOrganizationMemberHandler extends Handler

  @route 'delete /organizations/{organizationId}/users/{userId}'
  @demand 'is organization member'
  
  constructor: (log, @organizationService, @userService) ->
    super(log)

  handle: (request, reply) ->
    {organizationId, userId} = request.params
    @organizationService.get organizationId, (err, organization) =>
      return reply @error(err) if err?
      return reply @notFound() unless organization?
      @userService.get userId, (err, user) =>
        return reply @error(err) if err?
        return reply @notFound() unless user?
        @organizationService.removeMember organization, user, (err) =>
          return reply @error(err) if err?
          return reply()

module.exports = RemoveOrganizationMemberHandler
