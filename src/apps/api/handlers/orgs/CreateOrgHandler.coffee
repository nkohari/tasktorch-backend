_                  = require 'lodash'
async              = require 'async'
uuid               = require 'common/util/uuid'
Handler            = require 'apps/api/framework/Handler'
Org                = require 'data/documents/Org'
Kind               = require 'data/documents/Kind'
Stage              = require 'data/documents/Stage'
KindColor          = require 'data/enums/KindColor'
CreateOrgCommand   = require 'domain/commands/orgs/CreateOrgCommand'
CreateKindCommand  = require 'domain/commands/kinds/CreateKindCommand'
CreateStageCommand = require 'domain/commands/stages/CreateStageCommand'

class CreateOrgHandler extends Handler

  @route 'post /orgs'

  @ensure
    payload:
      name: @mustBe.string().required()
  
  constructor: (@processor) ->

  handle: (request, reply) ->

    {name} = request.payload
    {user} = request.auth.credentials

    org = new Org {
      name:    name
      leaders: [user.id]
      members: [user.id]
    }

    command = new CreateOrgCommand(user, org)
    @processor.execute command, (err, org) =>
      return reply err if err?
      @createDefaultKind user, org, (err) =>
        return reply err if err?
        return reply @response(org)

  createDefaultKind: (user, org, callback) ->

    kind = new Kind {
      id: uuid()
      org: org.id
      name: 'Task'
      description: 'General purpose, can be used to track anything',
      color: KindColor.Blue
    }

    stages = [
      new Stage {id: uuid(), org: org.id, kind: kind.id, name: 'Plan',   defaultActions: []}
      new Stage {id: uuid(), org: org.id, kind: kind.id, name: 'Do',     defaultActions: []}
      new Stage {id: uuid(), org: org.id, kind: kind.id, name: 'Verify', defaultActions: []}
    ]

    kind.stages = _.pluck(stages, 'id')

    createStage = (stage, next) =>
      command = new CreateStageCommand(user, stage)
      @processor.execute(command, next)

    async.eachSeries stages, createStage, (err) =>
      return callback(err) if err?
      command = new CreateKindCommand(user, kind)
      @processor.execute(command, callback)

module.exports = CreateOrgHandler
