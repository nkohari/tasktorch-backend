_                     = require 'lodash'
Handler               = require 'apps/api/framework/Handler'
DocumentArrayResponse = require 'apps/api/framework/DocumentArrayResponse'
Token                 = require 'data/documents/Token'
CreateTokensCommand   = require 'domain/commands/tokens/CreateTokensCommand'

class CreateTokensHandler extends Handler

  @route 'post /tokens'
  
  @ensure
    payload:
      tokens: @mustBe.array().items(
        @mustBe.object().keys {
          email:   @mustBe.string().required()
          comment: @mustBe.string()
        }
      )

  @before [
    'ensure requester is admin'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}    = request.pre
    {tokens} = request.payload
    {user}   = request.auth.credentials

    tokens = _.map tokens, (token) => new Token {
      creator: user.id
      email:   token.email
      comment: token.comment
    }

    command = new CreateTokensCommand(user, tokens)
    @processor.execute command, (err, tokens) =>
      return reply err if err?
      # TODO: Would be good to fit this into Handler.response() somehow
      response = new DocumentArrayResponse(Token, tokens)
      return reply(response)

module.exports = CreateTokensHandler
