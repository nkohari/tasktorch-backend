GetCardQuery           = require 'data/queries/GetCardQuery'
ChangeCardTitleCommand = require 'data/commands/ChangeCardTitleCommand'
CardTitleChangedEvent  = require 'data/events/CardTitleChangedEvent'
Error                  = require 'data/Error'
Handler                = require '../../framework/Handler'

class ChangeCardTitleHandler extends Handler

  @route 'put /api/{organizationId}/cards/{cardId}/title'
  @demand 'requester is organization member'

  constructor: (@database, @eventBus) ->

  handle: (request, reply) ->

    {user}   = request.auth.credentials
    {cardId} = request.params
    {title}  = request.payload
    metadata = @getRequestMetadata(request)

    command = new ChangeCardTitleCommand(cardId, title, request.expectedVersion)
    @database.execute command, (err, card, previous) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      event = new CardTitleChangedEvent(card, user)
      @eventBus.publish event, metadata, (err) =>
        return reply err if err?
        reply()

module.exports = ChangeCardTitleHandler
