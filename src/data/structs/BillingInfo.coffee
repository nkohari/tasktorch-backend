_ = require 'lodash'

class BillingInfo

  constructor: (data) ->
    @id      = data.id
    @balance = data.account_balance

module.exports = BillingInfo
