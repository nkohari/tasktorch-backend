Job = require 'domain/framework/Job'

class UpdateActiveUsersJob extends Job

  constructor: (@orgid) ->
    super()

module.exports = UpdateActiveUsersJob
