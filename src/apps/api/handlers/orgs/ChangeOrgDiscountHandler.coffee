_                            = require 'lodash'
Handler                      = require 'apps/api/framework/Handler'
AccountDiscount              = require 'data/structs/AccountDiscount'
ChangeAccountDiscountCommand = require 'domain/commands/accounts/ChangeAccountDiscountCommand'

class ChangeOrgDiscountHandler extends Handler

  @route 'post /{orgid}/discount'

  @ensure
    payload:
      discount: @mustBe.string().required()

  @before [
    'resolve org'
    'ensure org has active subscription'
    'ensure requester is leader of org'
  ]
  
  constructor: (@processor, stripe) ->
    @stripe = stripe.createClient()

  handle: (request, reply) ->

    {org}      = request.pre
    {user}     = request.auth.credentials
    {discount} = request.payload

    @stripe.coupons.list (err, coupons) =>
      return reply(err) if err?

      coupon = _.find coupons.data, (c) -> c.id == discount
      return reply @error.notFound() unless coupon?
      return reply @error.badRequest("That discount is no longer valid") unless coupon.valid

      @stripe.customers.update org.account.id, {coupon: coupon.id}, (err, subscription) =>
        return reply(err) if err?

        command = new ChangeAccountDiscountCommand(org.account.id, new AccountDiscount(subscription.discount.coupon))
        @processor.execute command, (err, org) =>
          return reply(err) if err?
          reply @response(org)

module.exports = ChangeOrgDiscountHandler
