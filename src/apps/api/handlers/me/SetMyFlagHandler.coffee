_                  = require 'lodash'
Handler            = require 'apps/api/framework/Handler'
UserFlag           = require 'data/enums/UserFlag'
SetUserFlagCommand = require 'domain/commands/users/SetUserFlagCommand'

class SetMyFlagHandler extends Handler

  @route 'post /me/flags'

  @ensure
    payload:
      flag:  @mustBe.valid(_.keys(UserFlag)).required()
      value: @mustBe.boolean().required()

  constructor: (@processor, @gatekeeper) ->

  handle: (request, reply) ->

    {user}        = request.auth.credentials
    {flag, value} = request.payload

    @gatekeeper.canUserSetFlag user, user, flag, value, (err, allowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to do that.") unless allowed

      command = new SetUserFlagCommand(user, flag, value)
      @processor.execute command, (err, user) =>
        return reply err if err?
        reply @response(user)

module.exports = SetMyFlagHandler
