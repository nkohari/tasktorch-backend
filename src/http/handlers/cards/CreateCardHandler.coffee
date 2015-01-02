_                 = require 'lodash'
CreateCardCommand = require 'domain/commands/CreateCardCommand'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'
CardStatus        = require 'data/enums/CardStatus'
StackType         = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/GetSpecialStackByUserQuery'
GetKindQuery = require 'data/queries/GetKindQuery'

class CreateCardHandler extends Handler

  @route 'post /api/{organizationId}/cards'
  @demand ['requester is organization member']

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {user}         = request.auth.credentials
    kindId         = request.payload?.kind

    @resolveStack organization, user, (err, stack) =>
      return reply err if err?
      @resolveKind kindId, (err, kind) =>
        return reply err if err?

        data =
          creator:      user.id
          owner:        user.id
          kind:         kind.id
          stack:        stack.id
          organization: organization.id
          participants: [user.id]

        command = new CreateCardCommand(user, data, stack.id)
        @processor.execute command, (err, result) =>
          return reply @error.notFound() if err is Error.DocumentNotFound
          return reply @error.conflict() if err is Error.VersionMismatch
          return reply err if err?
          reply new Response(result.card)

  resolveStack: (organization, user, callback) ->
    query = new GetSpecialStackByUserQuery(organization.id, user.id, StackType.Drafts)
    @database.execute query, (err, {stack}) =>
      return callback err if err?
      callback(null, stack)

  resolveKind: (id, callback) ->
    return callback @error.badRequest() unless id?
    query = new GetKindQuery(id)
    @database.execute query, (err, {kind}) =>
      return callback err if err?
      return callback @error.badRequest() unless kind?
      callback(null, kind)

module.exports = CreateCardHandler
