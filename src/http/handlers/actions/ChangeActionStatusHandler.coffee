_                         = require 'lodash'
Handler                   = require 'http/framework/Handler'
ChangeActionStatusCommand = require 'domain/commands/actions/ChangeActionStatusCommand'
ActionStatus              = require 'data/enums/ActionStatus'

class ChangeActionStatusHandler extends Handler

  @route 'post /api/{orgid}/actions/{actionid}/status'

  @ensure
    payload:
      status: @mustBe.valid(_.keys(ActionStatus)).required()

  @before [
    'resolve org'
    'resolve action'
    'ensure action belongs to org'
    'ensure requester can access action'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {action} = request.pre
    {status} = request.payload
    {user}   = request.auth.credentials

    command = new ChangeActionStatusCommand(user, action, status)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = ChangeActionStatusHandler
