Handler                    = require 'apps/api/framework/Handler'
AccountSource              = require 'data/structs/AccountSource'
ChangeAccountSourceCommand = require 'domain/commands/accounts/ChangeAccountSourceCommand'

class SetOrgCreditCardHandler extends Handler

  @route 'post /{orgid}/payment'

  @ensure
    payload:
      token: @mustBe.string().required()

  @before [
    'resolve org'
    'ensure requester is leader of org'
  ]
  
  constructor: (@processor, stripe) ->
    @stripe = stripe.createClient()

  handle: (request, reply) ->

    {org}   = request.pre
    {user}  = request.auth.credentials
    {token} = request.payload

    unless org.account?
      return reply @error.badRequest("The org #{org.id} does not have account information associated with it")

    @stripe.customers.createSource org.account.id, {source: token}, (err, card) =>
      return reply err if err?
      source  = new AccountSource(card)
      command = new ChangeAccountSourceCommand(org.account.id, source)
      @processor.execute command, (err, org) =>
        return reply err if err?
        reply @response(org)

module.exports = SetOrgCreditCardHandler
