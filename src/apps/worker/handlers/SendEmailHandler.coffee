JobHandler   = require 'apps/worker/framework/JobHandler'
SendEmailJob = require 'domain/jobs/SendEmailJob'

class SendEmailHandler extends JobHandler

  handles: SendEmailJob

  constructor: (@log, @emailRenderer, @emailSender) ->
    super()

  handle: (job, callback) ->

    try
      email = @emailRenderer.render(job)
    catch err
      return callback(err)

    @emailSender.send(email, callback)

module.exports = SendEmailHandler
