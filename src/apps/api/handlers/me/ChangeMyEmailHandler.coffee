Handler                = require 'apps/api/framework/Handler'
ChangeUserEmailCommand = require 'domain/commands/users/ChangeUserEmailCommand'

class ChangeMyEmailHandler extends Handler

  @route 'post /me/email'

  @ensure
    payload:
      email: @mustBe.string().required()

  constructor: (@processor) ->

  handle: (request, reply) ->

    {user}  = request.auth.credentials
    {email} = request.payload

    command = new ChangeUserEmailCommand(user, email)
    @processor.execute command, (err, user) =>
      return reply err if err?
      reply @response(user)

module.exports = ChangeMyEmailHandler
