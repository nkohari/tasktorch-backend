_                                  = require 'lodash'
Handler                            = require 'http/framework/Handler'
GetKindQuery                       = require 'data/queries/kinds/GetKindQuery'
MoveActionCommand                  = require 'domain/commands/actions/MoveActionCommand'
RepositionActionInChecklistCommand = require 'domain/commands/actions/RepositionActionInChecklistCommand'

class MoveActionHandler extends Handler

  @route 'post /api/{orgid}/actions/{actionid}/move'

  @ensure
    payload:
      checklist: @mustBe.string().required()
      position:  @mustBe.number().integer().allow('prepend', 'append').required()

  @before [
    'resolve org'
    'resolve action'
    'resolve checklist argument'
    'ensure action belongs to org'
    'ensure requester can access action'
    'ensure requester can access checklist'
    'ensure position argument is valid'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {action, checklist} = request.pre
    {position}          = request.payload
    {user}              = request.auth.credentials

    if action.checklist == checklist.id
      command = new RepositionActionInChecklistCommand(user, action.id, checklist.id, position)
      @processor.execute command, (err) =>
        return reply err if err?
        reply @response(action)
    else
      command = new MoveActionCommand(user, action.id, checklist.id, checklist.card, checklist.stage, position)
      @processor.execute command, (err, action) =>
        return reply err if err?
        reply @response(action)

module.exports = MoveActionHandler
