Handler               = require 'http/framework/Handler'
AddMemberToOrgCommand = require 'domain/commands/users/AddMemberToOrgCommand'

class AddMemberToOrgHandler extends Handler

  @route 'post /api/{orgid}/members'

  @validate
    payload:
      user: @mustBe.string().required()

  @pre [
    'resolve org'
    'resolve user argument'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, user} = request.pre
    requester   = request.auth.credentials.user

    if org.hasMember(user)
      return reply @response(org)

    command = new AddMemberToOrgCommand(requester, user, org)
    @processor.execute command, (err, org) =>
      return reply err if err?
      return reply @response(org)

module.exports = AddMemberToOrgHandler
