Activity           = require 'apps/watcher/framework/Activity'
Rule               = require 'apps/watcher/framework/Rule'
GetInviteQuery     = require 'data/queries/invites/GetInviteQuery'
SendInviteEmailJob = require 'domain/jobs/SendInviteEmailJob'

class SendInviteEmail extends Rule

  constructor: (@log, @config, @aws, @database) ->
    @sqs = @aws.createSQSClient()

  supports: (activity, event) ->
    activity == Activity.Created and event.type == 'Invite'

  handle: (activity, event, callback) ->
    @createJob event.document, (err, job) =>
      return callback(err) if err?
      @log.debug "[invite] Queueing SendInviteEmailJob for invite #{event.document.id} (#{event.document.email})"
      @sqs.sendMessage {
        QueueUrl:    @config.jobs.queueUrl
        MessageBody: JSON.stringify(job)
      }, callback

  createJob: (invite, callback) ->
    query = new GetInviteQuery(invite.id, {expand: ['creator', 'org']})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      {invite} = result
      org      = result.related.orgs[invite.org]
      creator  = result.related.users[invite.creator]
      job = new SendInviteEmailJob(invite, org, creator)
      callback(null, job)

module.exports = SendInviteEmail
