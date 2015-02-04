_                          = require 'lodash'
Handler                    = require 'http/framework/Handler'
Card                       = require 'data/documents/Card'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
CreateCardCommand          = require 'domain/commands/cards/CreateCardCommand'

class CreateCardHandler extends Handler

  @route 'post /api/{orgid}/cards'

  @validate
    payload:
      kind:    @mustBe.string().required()
      title:   @mustBe.string().allow(null)
      summary: @mustBe.string().allow(null)

  @pre [
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
      
      card = new Card {
        org:       org.id
        creator:   user.id
        owner:     user.id
        kind:      kind.id
        stack:     stack.id
        title:     title
        summary:   summary
        followers: [user.id]
        moves:     []
        actions:   _.object(_.map(kind.stages, (id) -> [id, []]))
      }

      command = new CreateCardCommand(user, card)
      @processor.execute command, (err, card) =>
        return reply err if err?
        reply @response(card)

module.exports = CreateCardHandler
