_                     = require 'lodash'
Handler               = require 'http/framework/Handler'
User                  = require 'data/documents/User'
GetOrgQuery           = require 'data/queries/orgs/GetOrgQuery'
CreateUserCommand     = require 'domain/commands/users/CreateUserCommand'
AddMemberToOrgCommand = require 'domain/commands/users/AddMemberToOrgCommand'

class CreateUserHandler extends Handler

  @route 'post /api/users'
  @auth  {mode: 'try'}
  
  @ensure
    payload:
      name:     @mustBe.string().required()
      username: @mustBe.string().required()
      password: @mustBe.string().required()
      email:    @mustBe.string().required()
      token:    @mustBe.string().required()

  @before [
    'resolve token argument'
  ]

  constructor: (@database, @processor, @passwordHasher) ->

  handle: (request, reply) ->

    {token} = request.pre
    {name, username, password, email} = request.payload

    user = new User {
      name:     name
      username: username
      password: @passwordHasher.hash(password)
      emails:   [email]
    }

    command = new CreateUserCommand(user, token)
    @processor.execute command, (err, user) =>
      return reply err if err?
      @addOrgMembership user, token, (err) =>
        return reply err if err?
        return reply @response(user)

  addOrgMembership: (user, token, callback) ->
    return callback() unless token.org?
    query = new GetOrgQuery(token.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.badRequest() unless result.org?
      command = new AddMemberToOrgCommand(user, user, result.org)
      @processor.execute(command, callback)

module.exports = CreateUserHandler
