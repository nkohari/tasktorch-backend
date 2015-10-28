Job = require 'domain/framework/Job'

class CreateIntercomCompanyJob extends Job

  constructor: (@org, @survey) ->
    super()

module.exports = CreateIntercomCompanyJob
