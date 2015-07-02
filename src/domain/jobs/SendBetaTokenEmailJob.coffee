Job   = require 'domain/framework/Job'
Model = require 'domain/framework/Model'

class SendBetaTokenEmailJob extends Job

  constructor: (token) ->
    super()
    @template = 'beta-token'
    @to = token.email
    @params = {
      token: Model.create(token)
    }

module.exports = SendBetaTokenEmailJob
