_                   = require 'lodash'
Handler             = require 'http/framework/Handler'
Action              = require 'data/documents/Action'
CreateActionCommand = require 'domain/commands/actions/CreateActionCommand'

class CreateActionHandler extends Handler

  @route 'post /{orgid}/checklists/{checklistid}/actions'

  @ensure
    payload:
      text: @mustBe.string().allow(null).required()

  @before [
    'resolve org'
    'resolve checklist'
    'ensure checklist belongs to org'
    'ensure requester can access checklist'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, checklist} = request.pre
    {text}           = request.payload
    {user}           = request.auth.credentials

    action = new Action {
      org:       org.id
      card:      checklist.card
      checklist: checklist.id
      stage:     checklist.stage
      text:      text
    }

    command = new CreateActionCommand(user, action)
    @processor.execute command, (err, action) =>
      return reply err if err?
      reply @response(action)

module.exports = CreateActionHandler
