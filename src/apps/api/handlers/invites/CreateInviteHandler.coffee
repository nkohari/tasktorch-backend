_                   = require 'lodash'
Handler             = require 'apps/api/framework/Handler'
Invite              = require 'data/documents/Invite'
CreateInviteCommand = require 'domain/commands/invites/CreateInviteCommand'

class CreateInviteHandler extends Handler

  @route 'post /{orgid}/invites'
  
  @ensure
    payload:
      email: @mustBe.string()

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}   = request.pre
    {email} = request.payload
    {user}  = request.auth.credentials

    invite = new Invite {
      org:     org.id
      creator: user.id
      email:   email
    }

    command = new CreateInviteCommand(user, invite)
    @processor.execute command, (err, invite) =>
      return reply err if err?
      return reply @response(invite)

module.exports = CreateInviteHandler
