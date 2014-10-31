_                 = require 'lodash'
CreateCardCommand = require 'data/commands/CreateCardCommand'
CardCreatedEvent  = require 'data/events/CardCreatedEvent'
Handler           = require 'http/framework/Handler'

class CreateCardHandler extends Handler

  @route 'post /api/{organizationId}/stacks/{stackId}/cards'
  @demand ['requester is organization member', 'requester is stack participant']

  constructor: (@database, @eventBus, @modelFactory) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {organization} = request.scope
    {cardId, stackId} = request.params
    metadata = @getRequestMetadata(request)

    card = _.extend request.payload,
      creator:      user.id
      stack:        stackId
      organization: organization.id
      participants: [user.id]

    # TODO: Validation. Will probably need to be async because of validating
    # the existence of the card's type/category/whatever we call it.

    command = new CreateCardCommand(card, metadata)
    @database.execute command, (err, card) =>
      return reply err if err?
      event = new CardCreatedEvent(card, user)
      @eventBus.publish event, metadata, (err) =>
        return reply err if err?
        model = @modelFactory.create(card, request)
        reply(model)
        .created(model.uri)
        .etag(model.version)

module.exports = CreateCardHandler
