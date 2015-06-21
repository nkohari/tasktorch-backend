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
      kind:    @mustBe.string().required()
      title:   @mustBe.string().allow(null)
      summary: @mustBe.string().allow(null)

  @before [
    'resolve org'
    'resolve kind argument'
    'ensure kind belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, kind}      = request.pre
    {title, summary} = request.payload
    {user}           = request.auth.credentials

    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Drafts)
    @database.execute query, (err, result) =>
      return reply err if err?
      {stack} = result

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

module.exports = CreateCardHandler
