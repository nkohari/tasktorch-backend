Activity       = require 'apps/watcher/framework/Activity'
Rule           = require 'apps/watcher/framework/Rule'
GetInviteQuery = require 'data/queries/invites/GetInviteQuery'
Model          = require 'domain/framework/Model'
SendEmailJob   = require 'domain/jobs/SendEmailJob'

class SendEmailWhenInviteCreated extends Rule

  constructor: (@log, @aws, @jobQueue) ->

  offer: (activity, event) ->
    activity == Activity.Created and event.type == 'Invite'

  handle: (activity, event, callback) ->
    invite = event.document
    query  = new GetInviteQuery(invite.id, {expand: ['creator', 'org']})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      
      {invite} = result
      org      = result.related.orgs[invite.org]
      creator  = result.related.users[invite.creator]

      job = new SendEmailJob('invite', {to: invite.email}, {
        invite: Model.create(invite)
        org:    Model.create(org)
        sender: Model.create(creator)
      })

      @log.debug "Creating SendEmailJob for invite #{invite.id} (#{invite.email})"
      @jobQueue.enqueue(job, callback)

module.exports = SendEmailWhenInviteCreated
