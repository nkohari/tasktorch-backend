RemoveLeaderFromOrgCommand = require 'domain/commands/users/RemoveLeaderFromOrgCommand'
Handler                     = require 'apps/api/framework/Handler'

class RemoveLeaderFromOrgHandler extends Handler

  @route 'delete /{orgid}/leaders/{userid}'

  @before [
    'resolve org'
    'resolve user'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, user} = request.pre
    requester   = request.auth.credentials.user

    if requester.id == user.id
      return reply @error.badRequest("You can't remove yourself as an org leader")

    unless org.hasLeader(user.id)
      return reply @error.badRequest("The user #{user.id} is not a leader of the org #{org.id}")

    unless org.leaders.length > 1
      return reply @error.badRequest("You can't remove the last leader from an org")

    command = new RemoveLeaderFromOrgCommand(requester, org, user)
    @processor.execute command, (err, org) =>
      return reply err if err?
      return reply @response(org)

module.exports = RemoveLeaderFromOrgHandler
