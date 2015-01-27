_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'
GetCardQuery      = require 'data/queries/GetCardQuery'
CommentNote       = require 'domain/documents/notes/CommentNote'
CreateNoteCommand = require 'domain/commands/note/CreateNoteCommand'

class CreateNoteHandler extends Handler

  @route 'post /api/{orgId}/cards/{cardId}/notes'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->
    @prepare request, [@getCardWithOrg], (err) =>
      return reply err if err?
      @validate request, (err) =>
        return reply err if err?
        @createNoteDocument request, (err, note) =>
          return reply err if err?
          command = new CreateNoteCommand(request.auth.credentials.user, note)
          @processor.execute command, (err, result) =>
            return reply @error.notFound() if err is Error.DocumentNotFound
            return reply @error.conflict() if err is Error.VersionMismatch
            return reply err if err?
            reply new Response(result.note)

  validate: (request, callback) ->
    if request.org.id != request.params.orgId
      return callback @error.forbidden()
    unless _.contains(request.org.members, request.auth.credentials.user.id)
      return callback @error.forbidden()
    callback()

  getCardWithOrg: (request, callback) ->
    query = new GetCardQuery(request.params.cardId, {expand: 'org'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      {card} = result
      return callback @error.notFound() unless card?
      request.card = card
      request.org = result.related.orgs[card.org]
      callback()

  # TODO: Improve this if we end up supporting additional note types.
  createNoteDocument: (request, callback) ->
    return callback @error.badRequest() unless request.payload.type?.length > 0
    switch request.payload.type
      when 'Comment'
        return callback @error.badRequest() unless request.payload.content?.length > 0
        note = new CommentNote(request.auth.credentials.user, request.card, request.payload.content)
      else
        return callback @error.badRequest()
    callback(null, note)

module.exports = CreateNoteHandler
