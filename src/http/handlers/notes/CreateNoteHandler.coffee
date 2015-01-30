Handler           = require 'http/framework/Handler'
CommentNote       = require 'data/documents/notes/CommentNote'
CreateNoteCommand = require 'domain/commands/notes/CreateNoteCommand'

class CreateNoteHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/notes'

  @pre [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {card}          = request.pre
    {user}          = request.auth.credentials
    {type, content} = request.payload

    unless type?.length > 0
      return reply @error.badRequest("Missing required argument 'type'")

    # TODO: Improve this if we end up supporting additional note types.
    switch type
      when 'Comment'
        unless content?.length > 0
          return reply @error.badRequest("Missing required argument 'content'")
        note = CommentNote.create(user, card, content)
      else
        return reply @error.badRequest()

    command = new CreateNoteCommand(user, note)
    @processor.execute command, (err, result) =>
      return reply err if err?
      reply @response(result.note)

module.exports = CreateNoteHandler
