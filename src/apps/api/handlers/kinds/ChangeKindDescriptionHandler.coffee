Handler                      = require 'apps/api/framework/Handler'
ChangeKindDescriptionCommand = require 'domain/commands/kinds/ChangeKindDescriptionCommand'

class ChangeKindDescriptionHandler extends Handler

  @route 'post /{orgid}/kinds/{kindid}/description'

  @ensure
    payload:
      description: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve kind'
    'ensure org has active subscription'
    'ensure kind belongs to org'
    'ensure requester can access kind'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, kind}   = request.pre
    {user}        = request.auth.credentials
    {description} = request.payload

    command = new ChangeKindDescriptionCommand(user, kind, description)
    @processor.execute command, (err, kind) =>
      return reply err if err?
      return reply @response(kind)

module.exports = ChangeKindDescriptionHandler
