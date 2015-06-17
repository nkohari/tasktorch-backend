Handler               = require 'http/framework/Handler'
ChangeUserNameCommand = require 'domain/commands/users/ChangeUserNameCommand'

class ChangeMyNameHandler extends Handler

  @route 'post /me/name'

  @ensure
    payload:
      name: @mustBe.string().required()

  constructor: (@processor) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {name} = request.payload

    command = new ChangeUserNameCommand(user, name)
    @processor.execute command, (err, user) =>
      return reply err if err?
      reply @response(user)

module.exports = ChangeMyNameHandler
