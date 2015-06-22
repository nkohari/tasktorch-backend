Job   = require 'domain/framework/Job'
Model = require 'domain/framework/Model'

class SendInviteEmailJob extends Job

  constructor: (invite, org, sender) ->
    super()
    @template = 'invite'
    @to = invite.email
    @params = {
      invite: Model.create(invite)
      org:    Model.create(org)
      sender: Model.create(sender)
    }

module.exports = SendInviteEmailJob
