Job = require 'domain/framework/Job'

class UpdateActiveMembersJob extends Job

  constructor: (@orgid) ->
    super()

module.exports = UpdateActiveMembersJob
