_                         = require 'lodash'
async                     = require 'async'
uuid                      = require 'common/util/uuid'
Handler                   = require 'apps/api/framework/Handler'
Kind                      = require 'data/documents/Kind'
Stage                     = require 'data/documents/Stage'
KindColor                 = require 'data/enums/KindColor'
CreateKindCommand         = require 'domain/commands/kinds/CreateKindCommand'
CreateInitialStageCommand = require 'domain/commands/stages/CreateInitialStageCommand'

class CreateKindHandler extends Handler

  @route 'post /{orgid}/kinds'

  @ensure
    payload:
      name:        @mustBe.string()
      description: @mustBe.string().allow('', null)
      color:       @mustBe.string().valid(_.keys(KindColor))
      stages:      @mustBe.array().items(
                     @mustBe.object().keys {
                       name:           @mustBe.string()
                       defaultActions: @mustBe.array().items {text: @mustBe.string()}
                     }
                   )

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials
    {name, description, color, stages} = request.payload

    kind = new Kind {
      id:          uuid()
      org:         org.id
      name:        name
      description: description
      color:       color
    }

    # TODO: Actual validation for stages/default actions

    async.mapSeries stages, ((stage, next) => @createStage(user, org, kind, stage, next)), (err, stages) =>
      return callback(err) if err?
      kind.stages = _.pluck(stages, 'id')
      command = new CreateKindCommand(user, kind)
      @processor.execute command, (err, kind) =>
        return reply err if err?
        reply @response(kind)

  createStage: (user, org, kind, data, callback) ->

    stage = new Stage {
      id:             uuid()
      org:            org.id
      kind:           kind.id
      name:           data.name
      defaultActions: data.defaultActions ? []
    }

    command = new CreateInitialStageCommand(user, stage)
    @processor.execute(command, callback)

module.exports = CreateKindHandler
