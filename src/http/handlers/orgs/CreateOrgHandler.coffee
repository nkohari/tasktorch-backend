_                = require 'lodash'
Handler          = require 'http/framework/Handler'
Org              = require 'data/documents/Org'
CreateOrgCommand = require 'domain/commands/orgs/CreateOrgCommand'

class CreateOrgHandler extends Handler

  @route 'post /api/orgs'

  @validate
    payload:
      name: @mustBe.string().required()
  
  constructor: (@processor) ->

  handle: (request, reply) ->

    {name} = request.payload
    {user} = request.auth.credentials

    org = new Org {
      name: name
      leaders: [user.id]
      members: [user.id]
    }

    command = new CreateOrgCommand(user, org)
    @processor.execute command, (err, org) =>
      return reply err if err?
      return reply @response(org)

module.exports = CreateOrgHandler
