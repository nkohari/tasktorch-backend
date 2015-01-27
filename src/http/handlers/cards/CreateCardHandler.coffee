_                          = require 'lodash'
Handler                    = require 'http/framework/Handler'
Response                   = require 'http/framework/Response'
CardStatus                 = require 'data/enums/CardStatus'
GetSpecialStackByUserQuery = require 'data/queries/GetSpecialStackByUserQuery'
GetKindQuery               = require 'data/queries/GetKindQuery'
StackType                  = require 'domain/enums/StackType'
CreateCardCommand          = require 'domain/commands/card/CreateCardCommand'

class CreateCardHandler extends Handler

  @route 'post /api/{orgId}/cards'
  @demand ['requester is org member']

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org}   = request.scope
    {user}  = request.auth.credentials
    kindId  = request.payload?.kind

    @resolveStack org, user, (err, stack) =>
      return reply err if err?
      @resolveKind kindId, (err, kind) =>
        return reply err if err?

        # TODO: Create a document model for this
        data =
          creator:      user.id
          owner:        user.id
          kind:         kind.id
          stack:        stack.id
          org: org.id
          followers:    [user.id]
          moves:        []
          actions:      _.object(_.map(kind.stages, (id) -> [id, []]))

        command = new CreateCardCommand(user, data, stack.id)
        @processor.execute command, (err, result) =>
          return reply @error.notFound() if err is Error.DocumentNotFound
          return reply @error.conflict() if err is Error.VersionMismatch
          return reply err if err?
          reply new Response(result.card)

  resolveStack: (org, user, callback) ->
    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Drafts)
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
