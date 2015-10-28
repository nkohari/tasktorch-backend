Handler               = require 'apps/api/framework/Handler'
ChangeOrgEmailCommand = require 'domain/commands/orgs/ChangeOrgEmailCommand'

class ChangeOrgEmailHandler extends Handler

  @route 'post /{orgid}/email'

  @ensure
    payload:
      email: @mustBe.string().required()

  @before [
    'resolve org'
    'ensure requester is leader of org'
  ]
  
  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}   = request.pre
    {user}  = request.auth.credentials
    {email} = request.payload

    command = new ChangeOrgEmailCommand(user, org, email)
    @processor.execute command, (err, org) =>
      return reply err if err?
      reply @response(org)

module.exports = ChangeOrgEmailHandler
