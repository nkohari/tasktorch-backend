Handler               = require 'apps/api/framework/Handler'
ChangeKindNameCommand = require 'domain/commands/kinds/ChangeKindNameCommand'

class ChangeKindNameHandler extends Handler

  @route 'post /{orgid}/kinds/{kindid}/name'

  @ensure
    payload:
      name: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve kind'
    'ensure kind belongs to org'
    'ensure requester can access kind'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, kind} = request.pre
    {user}      = request.auth.credentials
    {name}      = request.payload

    command = new ChangeKindNameCommand(user, kind, name)
    @processor.execute command, (err, kind) =>
      return reply err if err?
      return reply @response(kind)

module.exports = ChangeKindNameHandler
