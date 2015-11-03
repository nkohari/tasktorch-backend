_                              = require 'lodash'
Handler                        = require 'apps/api/framework/Handler'
Membership                     = require 'data/documents/Membership'
MembershipLevel                = require 'data/enums/MembershipLevel'
GetMembershipByOrgAndUserQuery = require 'data/queries/memberships/GetMembershipByOrgAndUserQuery'
CreateMembershipCommand        = require 'domain/commands/memberships/CreateMembershipCommand'

class AddMemberToOrgHandler extends Handler

  @route 'post /{orgid}/memberships'

  @ensure
    payload:
      user:  @mustBe.string().required()
      level: @mustBe.valid(_.keys(MembershipLevel)).default(MembershipLevel.Member)

  @before [
    'resolve org'
    'resolve user argument'
    'ensure requester is leader of org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    requester   = request.auth.credentials.user
    {org, user} = request.pre
    {level}     = request.payload

    query = new GetMembershipByOrgAndUserQuery(org.id, user.id)
    @database.execute query, (err, result) =>
      return reply err if err?

      {membership} = result
      if membership?
        return reply @error.badRequest("The user #{user.id} already has a membership (#{membership.id}) in org #{org.id}")

      membership = new Membership {
        org:   org.id
        user:  user.id
        level: level
      }

      command = new CreateMembershipCommand(requester, membership)
      @processor.execute command, (err, membership) =>
        return reply err if err?
        return reply @response(membership)

module.exports = AddMemberToOrgHandler
