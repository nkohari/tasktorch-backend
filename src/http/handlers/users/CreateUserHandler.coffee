_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
User              = require 'data/documents/User'
CreateUserCommand = require 'domain/commands/users/CreateUserCommand'

class CreateUserHandler extends Handler

  @route 'post /api/users'

  @validate
    payload:
      name:     @mustBe.string().required()
      username: @mustBe.string().required()
      password: @mustBe.string().required()
      email:    @mustBe.string().required()

  constructor: (@processor, @passwordHasher) ->

  handle: (request, reply) ->

    {name, username, password, email} = request.payload

    user = new User {
      name:     name
      username: username
      password: @passwordHasher.hash(password)
      emails:   [email]
    }

    command = new CreateUserCommand(user)
    @processor.execute command, (err, user) =>
      return reply err if err?
      return reply @response(user)

module.exports = CreateUserHandler
