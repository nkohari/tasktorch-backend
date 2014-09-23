Handler = require '../../framework/Handler'

class AddOrganizationMemberHandler extends Handler

  @route 'post /organizations/{organizationId}/users'
  @demand 'is organization member'

  constructor: (log, @organizationService, @userService) ->
    super(log)

  handle: (request, reply) ->
    {organizationId} = request.params
    {userId}         = request.payload
    @organizationService.get organizationId, (err, organization) =>
      return reply @error(err) if err?
      return reply @notFound() unless organization?
      @userService.get userId, (err, user) =>
        return reply @error(err) if err?
        return reply @notFound() unless user?
        @organizationService.addMember organization, user, (err) =>
          return reply @error(err) if err?
          return reply()

module.exports = AddOrganizationMemberHandler
