Model = require 'domain/framework/Model'

class InviteModel extends Model

  constructor: (invite) ->
    super(invite)
    @creator = invite.creator
    @org     = invite.org
    @email   = invite.email

module.exports = InviteModel
