_                  = require 'lodash'
Handler            = require 'apps/api/framework/Handler'
Token              = require 'data/documents/Token'
CreateTokenCommand = require 'domain/commands/tokens/CreateTokenCommand'

class CreateOrgTokenHandler extends Handler

  @route 'post /{orgid}/tokens'
  
  @ensure
    payload:
      comment: @mustBe.string().default(null)

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}     = request.pre
    {comment} = request.payload
    {user}    = request.auth.credentials

    token = new Token {
      org:     org.id
      creator: user.id
      comment: comment
    }

    command = new CreateTokenCommand(user, token)
    @processor.execute command, (err, token) =>
      return reply err if err?
      return reply @response(token)

module.exports = CreateOrgTokenHandler
