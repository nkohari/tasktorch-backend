Handler              = require 'apps/api/framework/Handler'
ChangeOrgNameCommand = require 'domain/commands/orgs/ChangeOrgNameCommand'

class ChangeOrgNameHandler extends Handler

  @route 'post /{orgid}/name'

  @ensure
    payload:
      name: @mustBe.string().required()

  @before [
    'resolve org'
    'ensure requester is leader of org'
  ]
  
  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials
    {name} = request.payload

    command = new ChangeOrgNameCommand(user, org, name)
    @processor.execute command, (err, org) =>
      return reply err if err?
      reply @response(org)

module.exports = ChangeOrgNameHandler
