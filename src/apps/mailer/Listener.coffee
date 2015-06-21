_     = require 'lodash'
async = require 'async'
aws   = require 'aws-sdk'

class Listener

  constructor: (@log, @config, @processor) ->
    @sqs = new aws.SQS {
      region:     @config.aws.region
      apiVersion: @config.aws.apiVersion
    }

  start: ->
    @log.debug "Polling #{@config.mailer.queueUrl} every #{@config.mailer.waitTimeSeconds} seconds"
    poll = () =>
      @receive =>
        setImmediate(poll) unless @stopRequested
    poll()

  stop: ->
    @stopRequested = true

  receive: (callback) ->

    @sqs.receiveMessage {
      QueueUrl:            @config.mailer.queueUrl
      WaitTimeSeconds:     @config.mailer.waitTimeSeconds
      MaxNumberOfMessages: @config.mailer.maxNumberOfMessages
    }, (err, result) =>

      if err?
        # TODO: Stop polling after a certain number of failures?
        @log.error "Error receiving messages from SQS: #{err}"
        return callback()

      unless result.Messages?.length > 0
        @log.debug "No messages available from SQS"
        return callback()

      jobs = _.map result.Messages, (msg) -> {
        id:      msg.MessageId
        handle:  msg.ReceiptHandle
        request: JSON.parse(msg.Body)
      }

      @log.debug "Received #{jobs.length} jobs from SQS"

      async.each jobs, ((job, next) => @handle(job, next)), callback

  handle: (job, callback) ->

    @log.debug "Processing job #{job.id}"

    @processor.process job.request, (err) =>

      if err?
        @log.error "Error while processing job #{job.id}: #{err.stack ? err}"
        return callback()

      @log.debug "Job #{job.id} processed successfully, removing it from SQS"

      @sqs.deleteMessage {
        QueueUrl:      @config.mailer.queueUrl
        ReceiptHandle: job.handle
      }, (err) =>
        if err?
          @log.error "Error deleting job #{job.id} from SQS: #{err}"
        else
          @log.debug "Job #{job.id} successfully deleted from SQS"
        callback()

module.exports = Listener
