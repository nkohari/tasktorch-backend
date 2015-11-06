_                     = require 'lodash'
Handler               = require 'apps/api/framework/Handler'
DocumentArrayResponse = require 'apps/api/framework/DocumentArrayResponse'
Invite                = require 'data/documents/Invite'
MembershipLevel       = require 'data/enums/MembershipLevel'
CreateInvitesCommand  = require 'domain/commands/invites/CreateInvitesCommand'

class CreateInvitesHandler extends Handler

  @route 'post /{orgid}/invites'
  
  @ensure
    payload:
      invites: @mustBe.array().required().min(1).items(
        @mustBe.object().keys {
          email: @mustBe.string().required()
          level: @mustBe.valid(_.keys(MembershipLevel)).default(MembershipLevel.Member)
        }
      )

  @before [
    'resolve org'
    'ensure requester is leader of org'
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
        level:   invite.level
      }

    command = new CreateInvitesCommand(user, invites)
    @processor.execute command, (err, invites) =>
      return reply err if err?
      # TODO: Would be good to fit this into Handler.response() somehow
      response = new DocumentArrayResponse(Invite, invites)
      return reply(response)

module.exports = CreateInvitesHandler
