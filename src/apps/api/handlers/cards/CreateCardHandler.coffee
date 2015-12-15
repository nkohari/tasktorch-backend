_                          = require 'lodash'
Handler                    = require 'apps/api/framework/Handler'
Card                       = require 'data/documents/Card'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
GetAllStagesByKindQuery    = require 'data/queries/stages/GetAllStagesByKindQuery'
CreateCardCommand          = require 'domain/commands/cards/CreateCardCommand'

class CreateCardHandler extends Handler

  @route 'post /{orgid}/cards'

  @ensure
    payload:
      stack:   @mustBe.string().allow(null)
      kind:    @mustBe.string().required()
      title:   @mustBe.string().allow(null)
      summary: @mustBe.string().allow(null)

  @before [
    'resolve org'
    'resolve optional stack argument'
    'resolve kind argument'
    'ensure org has active subscription'
    'ensure kind belongs to org'
    'ensure stack belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, kind, stack} = request.pre
    {title, summary}   = request.payload
    {user}             = request.auth.credentials

    @resolveStack org, user, stack, (err, stack) =>
      return reply err if err?

      query = new GetAllStagesByKindQuery(kind.id)
      @database.execute query, (err, result) =>
        return reply err if err?
        {stages} = result
        
        card = new Card {
          org:       org.id
          creator:   user.id
          user:      user.id
          kind:      kind.id
          stack:     stack.id
          title:     title
          summary:   summary
          followers: [user.id]
        }

        command = new CreateCardCommand(user, card, kind, stages)
        @processor.execute command, (err, card) =>
          return reply err if err?
          reply @response(card)

  resolveStack: (org, user, requestedStack, callback) ->
    return callback(null, requestedStack) if requestedStack?
    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Inbox)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      {stack} = result
      callback(null, stack)

module.exports = CreateCardHandler
