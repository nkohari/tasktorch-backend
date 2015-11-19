_                      = require 'lodash'
uuid                   = require 'common/util/uuid'
Handler                = require 'apps/api/framework/Handler'
Checklist              = require 'data/documents/Checklist'
Stage                  = require 'data/documents/Stage'
GetAllCardsByKindQuery = require 'data/queries/cards/GetAllCardsByKindQuery'
CreateStageCommand     = require 'domain/commands/stages/CreateStageCommand'

class CreateStageHandler extends Handler

  @route 'post /{orgid}/kinds/{kindid}/stages'

  @ensure
    payload:
      name: @mustBe.string().required()
      position: @mustBe.number().integer().allow('prepend', 'append')
      defaultActions: @mustBe.array().items {text: @mustBe.string()}

  @before [
    'resolve org'
    'resolve kind'
    'ensure org has active subscription'
    'ensure kind belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, kind} = request.pre
    {user}      = request.auth.credentials
    {name, position, defaultActions} = request.payload

    stage = new Stage {
      id:             uuid()
      org:            org.id
      kind:           kind.id
      name:           name
      defaultActions: defaultActions ? []
    }

    @createChecklists stage, (err, checklists) =>
      return reply err if err?
      command = new CreateStageCommand(user, stage, position ? 'append', checklists)
      @processor.execute command, (err, stage) =>
        return reply err if err?
        return reply @response(stage)

  createChecklists: (stage, callback) ->
    query = new GetAllCardsByKindQuery(stage.kind)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      {cards} = result
      return callback() unless cards?
      checklists = _.map cards, (card) => new Checklist {
        card:  card.id
        org:   stage.org
        stage: stage.id
      }
      callback(null, checklists)

module.exports = CreateStageHandler
