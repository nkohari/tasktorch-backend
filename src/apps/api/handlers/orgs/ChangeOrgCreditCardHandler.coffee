Handler                    = require 'apps/api/framework/Handler'
AccountSource              = require 'data/structs/AccountSource'
ChangeAccountSourceCommand = require 'domain/commands/accounts/ChangeAccountSourceCommand'

class ChangeOrgCreditCardHandler extends Handler

  @route 'post /{orgid}/payment'

  @ensure
    payload:
      token: @mustBe.string().required()

  @before [
    'resolve org'
    'ensure org has active subscription'
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

    @deleteExistingCardIfNecessary org.account, (err) =>
      return reply err if err?
      @stripe.customers.createSource org.account.id, {source: token}, (err, card) =>
        return reply err if err?
        source  = new AccountSource(card)
        command = new ChangeAccountSourceCommand(org.account.id, source)
        @processor.execute command, (err, org) =>
          return reply err if err?
          reply @response(org)

  deleteExistingCardIfNecessary: (account, callback) ->
    return callback() unless account.source?
    @stripe.customers.deleteCard account.id, account.source.id, (err) =>
      return callback(err) if err?
      callback()

module.exports = ChangeOrgCreditCardHandler
