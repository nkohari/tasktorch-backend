Handler             = require 'http/framework/Handler'
HandOffCardCommand  = require 'data/commands/HandOffCardCommand'
StackType           = require 'data/enums/StackType'
CardHandedOffEvent  = require 'data/events/CardHandedOffEvent'
GetInboxByTeamQuery = require 'data/queries/GetInboxByTeamQuery'
GetSpecialStackByOrganizationAndUserQuery = require 'data/queries/GetSpecialStackByOrganizationAndUserQuery'

class HandOffCardHandler extends Handler

  @route 'put /api/{organizationId}/cards/{cardId}/handoff'
  @demand 'requester is organization member'

  constructor: (@database, @eventBus) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {organization} = request.scope
    model = new HandOffCardModel(request)
    metadata = @getRequestMetadata(request)

    if model.user?
      query = new GetSpecialStackByOrganizationAndUserQuery(organization.id, model.user, StackType.Inbox)
    else if model.team?
      query = new GetInboxByTeamQuery(model.team)
    else
      return reply @error.badRequest()

    # TODO: Validate request model

    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest() unless result.stack?
      command = new HandOffCardCommand(model.card, result.stack.id, model.user ? null)
      @database.execute command, (err, {card, oldStack, newStack}) =>
        return reply err if err?
        event = new CardHandedOffEvent(organization, user, card, oldStack, newStack)
        @eventBus.publish event, @getRequestMetadata(request), (err) =>
          return reply err if err?
          reply(event)

class HandOffCardModel

  constructor: (request) ->
    @card = request.params.cardId
    @user = request.payload.user
    @team = request.payload.team
    @message = request.payload.message

module.exports = HandOffCardHandler
