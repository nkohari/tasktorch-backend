_                          = require 'lodash'
Handler                    = require 'apps/api/framework/Handler'
RemoveMemberFromOrgCommand = require 'domain/commands/users/RemoveMemberFromOrgCommand'

class RemoveMemberFromOrgHandler extends Handler

  @route 'delete /{orgid}/members/{userid}'

  @before [
    'resolve org'
    'resolve user'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, user} = request.pre
    requester   = request.auth.credentials.user

    unless org.hasMember(user.id)
      return reply @error.badRequest("The user #{user.id} is not a member of the org #{org.id}")

    command = new RemoveMemberFromOrgCommand(requester, org, user)
    @processor.execute command, (err, org) =>
      return reply err if err?
      return reply @response(org)

module.exports = RemoveMemberFromOrgHandler
