Activity              = require 'apps/watcher/framework/Activity'
Rule                  = require 'apps/watcher/framework/Rule'
SendBetaTokenEmailJob = require 'domain/jobs/SendBetaTokenEmailJob'

class SendBetaTokenEmail extends Rule

  constructor: (@log, @config, @aws, @database) ->
    @sqs = @aws.createSQSClient()

  offer: (activity, event) ->
    activity == Activity.Created and event.type == 'Token'

  handle: (activity, event, callback) ->
    job = new SendBetaTokenEmailJob(event.document)
    @log.debug "[beta-token] Queueing SendBetaTokenEmailJob for token #{event.document.id} (#{event.document.email})"
    @sqs.sendMessage {
      QueueUrl:    @config.jobs.queueUrl
      MessageBody: JSON.stringify(job)
    }, callback

module.exports = SendBetaTokenEmail
