_                         = require 'lodash'
async                     = require 'async'
uuid                      = require 'common/util/uuid'
Handler                   = require 'apps/api/framework/Handler'
Org                       = require 'data/documents/Org'
Kind                      = require 'data/documents/Kind'
Membership                = require 'data/documents/Membership'
Stage                     = require 'data/documents/Stage'
KindColor                 = require 'data/enums/KindColor'
MembershipLevel           = require 'data/enums/MembershipLevel'
CreateOrgCommand          = require 'domain/commands/orgs/CreateOrgCommand'
CreateKindCommand         = require 'domain/commands/kinds/CreateKindCommand'
CreateMembershipCommand   = require 'domain/commands/memberships/CreateMembershipCommand'
CreateInitialStageCommand = require 'domain/commands/stages/CreateInitialStageCommand'

class CreateOrgHandler extends Handler

  @route 'post /orgs'

  @ensure
    payload:
      name:   @mustBe.string().required()
      email:  @mustBe.string()
      survey: @mustBe.object()
  
  constructor: (@processor, @onboarder) ->

  handle: (request, reply) ->

    {name, email, survey} = request.payload
    {user}                = request.auth.credentials

    org = new Org {
      name:   name
      email:  if email?.length > 0 then email else user.email
      survey: survey
    }

    command = new CreateOrgCommand(user, org)
    @processor.execute command, (err, org) =>
      return reply err if err?
      @createDefaultKind user, org, (err) =>
        return reply err if err?
        @createMembership user, org, (err) =>
          return reply err if err?
          @onboarder.createSampleCardIfNecessary user, org, (err) =>
            return reply err if err?
            return reply @response(org)

  createMembership: (user, org, callback) ->

    membership = new Membership {
      user:  user
      org:   org
      level: MembershipLevel.Leader
    }

    command = new CreateMembershipCommand(user, membership)
    @processor.execute(command, callback)

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
      command = new CreateInitialStageCommand(user, stage)
      @processor.execute(command, next)

    async.eachSeries stages, createStage, (err) =>
      return callback(err) if err?
      command = new CreateKindCommand(user, kind)
      @processor.execute(command, callback)

module.exports = CreateOrgHandler
