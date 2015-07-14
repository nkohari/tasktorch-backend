Handler               = require 'apps/api/framework/Handler'
AddLeaderToOrgCommand = require 'domain/commands/users/AddLeaderToOrgCommand'

class AddLeaderToOrgHandler extends Handler

  @route 'post /{orgid}/leaders'

  @ensure
    payload:
      user: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve user argument'
    'ensure requester can access org'
    'ensure user argument is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, user} = request.pre
    requester   = request.auth.credentials.user

    if org.hasLeader(user)
      return reply @response(org)

    command = new AddLeaderToOrgCommand(requester, org, user)
    @processor.execute command, (err, org) =>
      return reply err if err?
      return reply @response(org)

module.exports = AddLeaderToOrgHandler
