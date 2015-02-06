Handler           = require 'http/framework/Handler'
CommentNote       = require 'data/documents/notes/CommentNote'
CreateNoteCommand = require 'domain/commands/notes/CreateNoteCommand'

class CreateNoteHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/notes'

  @ensure
    payload:
      type:    @mustBe.string().required()
      content: @mustBe.any().required()

  @before [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {card}          = request.pre
    {user}          = request.auth.credentials
    {type, content} = request.payload

    # TODO: Improve this if we end up supporting additional note types.
    switch type
      when 'Comment'
        unless content?.length > 0
          return reply @error.badRequest("Missing required argument 'content'")
        note = CommentNote.create(user, card, content)
      else
        return reply @error.badRequest()

    command = new CreateNoteCommand(user, note)
    @processor.execute command, (err, note) =>
      return reply err if err?
      reply @response(note)

module.exports = CreateNoteHandler
