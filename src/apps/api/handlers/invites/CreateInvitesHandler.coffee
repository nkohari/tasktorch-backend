_                     = require 'lodash'
Handler               = require 'apps/api/framework/Handler'
DocumentArrayResponse = require 'apps/api/framework/DocumentArrayResponse'
Invite                = require 'data/documents/Invite'
CreateInvitesCommand  = require 'domain/commands/invites/CreateInvitesCommand'

class CreateInvitesHandler extends Handler

  @route 'post /{orgid}/invites'
  
  @ensure
    payload:
      invites: @mustBe.array().items(
        @mustBe.object().keys {
          email:  @mustBe.string().required()
          leader: @mustBe.boolean()
        }
      )

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}     = request.pre
    {invites} = request.payload
    {user}    = request.auth.credentials

    invites = _.map invites, (invite) =>
      new Invite {
        org:     org.id
        orgName: org.name
        creator: user.id
        email:   invite.email
        leader:  invite.leader
      }

    command = new CreateInvitesCommand(user, invites)
    @processor.execute command, (err, invites) =>
      return reply err if err?
      # TODO: Would be good to fit this into Handler.response() somehow
      response = new DocumentArrayResponse(Invite, invites)
      return reply(response)

module.exports = CreateInvitesHandler
