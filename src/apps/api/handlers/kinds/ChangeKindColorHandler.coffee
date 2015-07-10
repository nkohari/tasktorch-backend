_                      = require 'lodash'
Handler                = require 'apps/api/framework/Handler'
KindColor              = require 'data/enums/KindColor'
ChangeKindColorCommand = require 'domain/commands/kinds/ChangeKindColorCommand'

class ChangeKindColorHandler extends Handler

  @route 'post /{orgid}/kinds/{kindid}/color'

  @ensure
    payload:
      color: @mustBe.string().valid(_.keys(KindColor))

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
    {color}     = request.payload

    command = new ChangeKindColorCommand(user, kind, color)
    @processor.execute command, (err, kind) =>
      return reply err if err?
      return reply @response(kind)

module.exports = ChangeKindColorHandler
