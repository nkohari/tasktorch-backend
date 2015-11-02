Handler                = require 'apps/api/framework/Handler'
AddMemberToOrgCommand  = require 'domain/commands/users/AddMemberToOrgCommand'
UpdateActiveMembersJob = require 'domain/jobs/UpdateActiveMembersJob'

class AddMemberToOrgHandler extends Handler

  @route 'post /{orgid}/members'

  @ensure
    payload:
      user: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve user argument'
    'ensure requester can access org'
  ]

  constructor: (@processor, @jobQueue) ->

  handle: (request, reply) ->

    {org, user} = request.pre
    requester   = request.auth.credentials.user

    if org.hasMember(user)
      return reply @response(org)

    command = new AddMemberToOrgCommand(requester, user, org)
    @processor.execute command, (err, org) =>
      return reply err if err?
      job = new UpdateActiveMembersJob(org.id)
      @jobQueue.enqueue job, (err) =>
        return reply @response(org)

module.exports = AddMemberToOrgHandler
