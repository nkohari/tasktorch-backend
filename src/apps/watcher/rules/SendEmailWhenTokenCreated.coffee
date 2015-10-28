Activity     = require 'apps/watcher/framework/Activity'
Rule         = require 'apps/watcher/framework/Rule'
Model        = require 'domain/framework/Model'
SendEmailJob = require 'domain/jobs/SendEmailJob'

class SendEmailWhenTokenCreated extends Rule

  constructor: (@log, @jobQueue) ->

  offer: (activity, event) ->
    activity == Activity.Created and event.type == 'Token'

  handle: (activity, event, callback) ->
    token = event.document

    job = new SendEmailJob('beta-token', {to: token.email}, {
      token: Model.create(token)
    })

    @log.debug "Creating SendEmailJob for beta token #{token.id} (#{token.email})"
    @jobQueue.enqueue(job, callback)

module.exports = SendEmailWhenTokenCreated
