_                   = require 'lodash'
Handler             = require 'apps/api/framework/Handler'
User                = require 'data/documents/User'
GetOrgQuery         = require 'data/queries/orgs/GetOrgQuery'
AcceptInviteCommand = require 'domain/commands/invites/AcceptInviteCommand'
AcceptTokenCommand  = require 'domain/commands/tokens/AcceptTokenCommand'
CreateUserCommand   = require 'domain/commands/users/CreateUserCommand'

class CreateUserHandler extends Handler

  @route 'post /users'
  @auth  {mode: 'try'}
  
  @ensure
    payload:
      name:     @mustBe.string().required()
      username: @mustBe.string().required()
      password: @mustBe.string().required()
      email:    @mustBe.string().required()
      token:    @mustBe.string()
      invite:   @mustBe.string()

  @before [
    'resolve optional token argument'
    'resolve optional invite argument'
    'ensure token is pending'
    'ensure invite is pending'
  ]

  constructor: (@database, @processor, @passwordHasher) ->

  handle: (request, reply) ->

    {token, invite} = request.pre
    {name, username, password, email} = request.payload

    if not token? and not invite?
      return reply @error.badRequest("Either an invite or a token must be provided")

    user = new User {
      name:     name
      username: username
      password: @passwordHasher.hash(password)
      email:    email
    }

    command = new CreateUserCommand(user)
    @processor.execute command, (err, user) =>
      return reply err if err?
      @acceptTokenIfProvided user, token, (err) =>
        return reply err if err?
        return reply @response(user)
        @acceptInviteIfProvided user, invite, (err) =>
          return reply err if err?
          return reply @response(user)

  acceptTokenIfProvided: (user, token, callback) ->
    return callback() unless token?
    command = new AcceptTokenCommand(user, user, token)
    @processor.execute(command, callback)

  acceptInviteIfProvided: (user, invite, callback) ->
    return callback() unless invite?
    command = new AcceptInviteCommand(user, user, invite)
    @processor.execute(command, callback)

module.exports = CreateUserHandler
