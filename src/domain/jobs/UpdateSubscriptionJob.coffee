Job = require 'domain/framework/Job'

class UpdateSubscriptionJob extends Job

  constructor: (@orgid) ->
    super()

module.exports = UpdateSubscriptionJob
