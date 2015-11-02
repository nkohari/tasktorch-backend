_ = require 'lodash'

class AccountInfo

  constructor: (data) ->
    @id      = data.id
    @balance = data.account_balance

module.exports = AccountInfo
