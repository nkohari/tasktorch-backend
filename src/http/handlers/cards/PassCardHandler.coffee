PassCardCommand            = require 'domain/commands/card/PassCardCommand'
StackType                  = require 'domain/enums/StackType'
GetInboxByTeamQuery        = require 'data/queries/GetInboxByTeamQuery'
GetSpecialStackByUserQuery = require 'data/queries/GetSpecialStackByUserQuery'
Handler                    = require 'http/framework/Handler'
Response                   = require 'http/framework/Response'

class PassCardHandler extends Handler

  @route  'put /api/{organizationId}/cards/{cardId}/pass'
  @demand 'requester is organization member'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {user}         = request.auth.credentials
    {organization} = request.scope
    model          = @createRequestModel(request)

    @resolveStack organization, model, (err, stack) =>
      return reply err if err?
      command = new PassCardCommand(user, model.card, stack.id, model.user ? null)
      @processor.execute command, (err, result) =>
        return reply @error.notFound() if err is Error.DocumentNotFound
        return reply @error.conflict() if err is Error.VersionMismatch
        return reply err if err?
        reply new Response(result.card)

  resolveStack: (organization, model, callback) ->
    if model.user?
      query = new GetSpecialStackByUserQuery(organization.id, model.user, StackType.Inbox)
    else if model.team?
      query = new GetInboxByTeamQuery(model.team)
    else
      return callback @error.badRequest()
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.badRequest() unless result.stack?
      callback(null, result.stack)

  createRequestModel: (request) ->
    return {
      card:    request.params.cardId
      user:    request.payload.user
      team:    request.payload.team
      message: request.payload.message
    }

module.exports = PassCardHandler
