Handler                   = require 'http/framework/Handler'
ChangeUserPasswordCommand = require 'domain/commands/users/ChangeUserPasswordCommand'

class ChangeMyPasswordHandler extends Handler

  @route 'post /me/password'

  @ensure
    payload:
      password: @mustBe.string().required()
  
  constructor: (@processor, @passwordHasher) ->

  handle: (request, reply) ->

    {user}     = request.auth.credentials
    {password} = request.payload

    hashedPassword = @passwordHasher.hash(password)
    command = new ChangeUserPasswordCommand(user, hashedPassword)
    @processor.execute command, (err, user) =>
      return reply err if err?
      reply()

module.exports = ChangeMyPasswordHandler
