_                       = require 'lodash'
AccountDiscountDuration = require 'data/enums/AccountDiscountDuration'

class AccountDiscount

  constructor: (data) ->
    @id             = data.id
    @amountOff      = data.amount_off
    @percentOff     = data.percent_off
    @duration       = @convertDuration(data.duration)
    @durationMonths = data.duration_in_months

  convertDuration: (str) ->
    switch str
      when 'forever'   then AccountDiscountDuration.Forever
      when 'repeating' then AccountDiscountDuration.Repeating
      when 'once'      then AccountDiscountDuration.Once
      else
        throw new Error("Unknown discount duration #{str}")

module.exports = AccountDiscount
