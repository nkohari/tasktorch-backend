_                           = require 'lodash'
async                       = require 'async'
Action                      = require 'data/documents/Action'
Card                        = require 'data/documents/Card'
ActionStatus                = require 'data/enums/ActionStatus'
StackType                   = require 'data/enums/StackType'
GetAllChecklistsByCardQuery = require 'data/queries/checklists/GetAllChecklistsByCardQuery'
GetKindQuery                = require 'data/queries/kinds/GetKindQuery'
GetAllOrgsByMemberQuery     = require 'data/queries/orgs/GetAllOrgsByMemberQuery'
GetSpecialStackByUserQuery  = require 'data/queries/stacks/GetSpecialStackByUserQuery'
GetAllStagesByKindQuery     = require 'data/queries/stages/GetAllStagesByKindQuery'
CreateActionCommand         = require 'domain/commands/actions/CreateActionCommand'
CreateCardCommand           = require 'domain/commands/cards/CreateCardCommand'

SAMPLE_CARD =
  kind: 'onboarding-kind'
  title: 'Get started with TaskTorch'
  actions: [
    {stage: 'onboarding-stage-setup',     text: 'Create your account',      status: ActionStatus.Complete}
    {stage: 'onboarding-stage-setup',     text: 'Log in',                   status: ActionStatus.Complete}
    {stage: 'onboarding-stage-learn',     text: 'Complete the walkthrough', status: ActionStatus.InProgress}
    {stage: 'onboarding-stage-nextsteps', text: 'Invite a coworker',        status: ActionStatus.NotStarted}
    {stage: 'onboarding-stage-nextsteps', text: 'Create a card',            status: ActionStatus.NotStarted}
    {stage: 'onboarding-stage-nextsteps', text: 'Create a team',            status: ActionStatus.NotStarted}
    {stage: 'onboarding-stage-nextsteps', text: 'Pass a card to someone',   status: ActionStatus.NotStarted}
  ]

class Onboarder

  constructor: (@log, @database, @processor) ->

  createSampleCardIfNecessary: (user, org, callback) ->
    query = new GetAllOrgsByMemberQuery(user.id)
    @database.execute query, (err, result) =>
      return callback err if err?
      {orgs} = result
      # If the user is a member of more than one organization, we should assume they've
      # already seen the walkthrough and don't need to be onboarded.
      if orgs.length > 1
        return callback()
      else
        @createSampleCard(user, orgs[0], callback)

  createSampleCard: (user, org, callback) ->

    query = new GetKindQuery(SAMPLE_CARD.kind)
    @database.execute query, (err, result) =>
      return callback err if err?
      {kind} = result

      query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Queue)
      @database.execute query, (err, result) =>
        return callback err if err?
        {stack} = result

        query = new GetAllStagesByKindQuery(kind.id)
        @database.execute query, (err, result) =>
          return callback err if err?
          {stages} = result

          card = new Card {
            org:     org.id
            creator: user.id
            user:    user.id
            kind:    kind.id
            stack:   stack.id
            title:   SAMPLE_CARD.title
            number:  1
          }

          command = new CreateCardCommand(user, card, kind, stages)
          @processor.execute command, (err, card) =>
            return callback err if err?

            query = new GetAllChecklistsByCardQuery(card.id)
            @database.execute query, (err, result) =>
              return callback err if err?

              checklists = _.object _.map result.checklists, (checklist) -> [checklist.stage, checklist]
              @log.inspect checklists

              createAction = (data, next) =>
                action = new Action {
                  org:       org.id
                  card:      card.id
                  checklist: checklists[data.stage].id
                  stage:     data.stage
                  text:      data.text
                  status:    data.status
                  user:      user.id
                }
                command = new CreateActionCommand(user, action)
                @processor.execute(command, next)

              async.each(SAMPLE_CARD.actions, createAction, callback)

module.exports = Onboarder