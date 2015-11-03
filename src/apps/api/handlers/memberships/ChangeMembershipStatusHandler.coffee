_                             = require 'lodash'
Handler                       = require 'apps/api/framework/Handler'
MembershipStatus              = require 'data/enums/MembershipStatus'
ChangeMembershipStatusCommand = require 'domain/commands/memberships/ChangeMembershipStatusCommand'

class ChangeMembershipStatusHandler extends Handler

  @route 'post /{orgid}/memberships/{membershipid}/status'

  @ensure
    payload:
      status: @mustBe.valid(_.keys(MembershipStatus)).required()

  @before [
    'resolve org'
    'resolve membership'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    user              = request.auth.credentials.user
    {org, membership} = request.pre
    status            = request.payload

    if user.id == membership.user
      return reply @error.badRequest("You can't change your own membership status")

    command = new ChangeMembershipStatusCommand(membership, status)
    @processor.execute command, (err, membership) =>
      return reply err if err?
      return reply @response(membership)

module.exports = ChangeMembershipStatusHandler
