Handler                   = require 'apps/api/framework/Handler'
AcceptInviteCommand       = require 'domain/commands/invites/AcceptInviteCommand'
CreateSessionCommand      = require 'domain/commands/sessions/CreateSessionCommand'
ChangeUserTimezoneCommand = require 'domain/commands/users/ChangeUserTimezoneCommand'
Session                   = require 'data/documents/Session'
GetUserByUsernameQuery    = require 'data/queries/users/GetUserByUsernameQuery'
GetUserByEmailQuery       = require 'data/queries/users/GetUserByEmailQuery'

class CreateSessionHandler extends Handler

  @route 'post /sessions'
  @auth  {mode: 'try'}

  @ensure
    payload:
      login:    @mustBe.string().required()
      password: @mustBe.string().required()
      timezone: @mustBe.string()
      invite:   @mustBe.string()

  @before [
    'resolve optional invite argument'
  ]

  constructor: (@log, @database, @processor, @passwordHasher) ->

  handle: (request, reply) ->

    {login, password, timezone} = request.payload
    {invite} = request.pre

    @resolveUser login, (err, user) =>
      return reply err if err?
      return reply @error.forbidden() unless user? and @passwordHasher.verify(user.password, password)
      @updateTimezoneIfNecessary user, timezone, (err) =>
        return reply err if err?
        @acceptInviteIfProvided user, invite, (err) =>
          return reply err if err?
          session = new Session {user: user.id, isActive: true}
          command = new CreateSessionCommand(user, session)
          @processor.execute command, (err, session) =>
            return reply err if err?
            request.auth.session.set {userid: user.id, sessionid: session.id}
            reply.state('tt-userid', user.id)
            reply @response(session)

  resolveUser: (login, callback) ->
    query = new GetUserByUsernameQuery(login)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback(null, result.user) if result.user?
      query = new GetUserByEmailQuery(login)
      @database.execute query, (err, result) =>
        return callback(err) if err?
        callback(null, result.user)

  updateTimezoneIfNecessary: (user, timezone, callback) ->
    return callback() if not timezone? or user.timezone == timezone
    command = new ChangeUserTimezoneCommand(user, timezone)
    @processor.execute(command, callback)

  acceptInviteIfProvided: (user, invite, callback) ->
    return callback() unless invite?
    command = new AcceptInviteCommand(user, user, invite)
    @processor.execute(command, callback)

module.exports = CreateSessionHandler
