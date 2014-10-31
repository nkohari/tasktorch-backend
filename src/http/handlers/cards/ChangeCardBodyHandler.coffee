GetCardQuery          = require 'data/queries/GetCardQuery'
ChangeCardBodyCommand = require 'data/commands/ChangeCardBodyCommand'
CardBodyChangedEvent  = require 'data/events/CardBodyChangedEvent'
Error                 = require 'data/Error'
Handler               = require 'http/framework/Handler'
Header                = require 'http/Header'

class ChangeCardBodyHandler extends Handler

  @route 'put /api/{organizationId}/cards/{cardId}/body'
  @demand 'requester is organization member'

  constructor: (@database, @eventBus) ->

  handle: (request, reply) ->

    {user}   = request.auth.credentials
    {cardId} = request.params
    {body}   = request.payload
    metadata = @getRequestMetadata(request)

    command = new ChangeCardBodyCommand(cardId, body, request.expectedVersion)
    @database.execute command, (err, card, previous) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      event = new CardBodyChangedEvent(card, user)
      @eventBus.publish event, metadata, (err) =>
        return reply err if err?
        reply()
        .etag(event.document.version)
        .header(Header.Event, event.id)

module.exports = ChangeCardBodyHandler
