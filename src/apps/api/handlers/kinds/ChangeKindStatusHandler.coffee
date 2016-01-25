_                       = require 'lodash'
Handler                 = require 'apps/api/framework/Handler'
KindStatus              = require 'data/enums/KindStatus'
ChangeKindStatusCommand = require 'domain/commands/kinds/ChangeKindStatusCommand'

class ChangeKindStatusHandler extends Handler

  @route 'post /{orgid}/kinds/{kindid}/status'

  @ensure
    payload:
      status: @mustBe.string().valid(_.keys(KindStatus))

  @before [
    'resolve org'
    'resolve kind'
    'ensure org has active subscription'
    'ensure kind belongs to org'
    'ensure requester can access kind'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, kind} = request.pre
    {user}      = request.auth.credentials
    {status}    = request.payload

    if kind.status == status
      return reply @error.badRequest("The kind already has status #{status}")

    command = new ChangeKindStatusCommand(user, kind, status)
    @processor.execute command, (err, kind) =>
      return reply err if err?
      return reply @response(kind)

module.exports = ChangeKindStatusHandler
