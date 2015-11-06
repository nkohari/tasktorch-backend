_                            = require 'lodash'
Handler                      = require 'apps/api/framework/Handler'
MembershipLevel              = require 'data/enums/MembershipLevel'
ChangeMembershipLevelCommand = require 'domain/commands/memberships/ChangeMembershipLevelCommand'

class ChangeMembershipLevelHandler extends Handler

  @route 'post /{orgid}/memberships/{membershipid}/level'

  @ensure
    payload:
      level: @mustBe.valid(_.keys(MembershipLevel)).required()

  @before [
    'resolve org'
    'resolve membership'
    'ensure membership belongs to org'
    'ensure requester is leader of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    user              = request.auth.credentials.user
    {org, membership} = request.pre
    {level}           = request.payload

    if user.id == membership.user
      return reply @error.badRequest("You can't change your own membership level")

    command = new ChangeMembershipLevelCommand(membership, level)
    @processor.execute command, (err, membership) =>
      return reply err if err?
      return reply @response(membership)

module.exports = ChangeMembershipLevelHandler
