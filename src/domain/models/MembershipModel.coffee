Model = require 'domain/framework/Model'

class MembershipModel extends Model

  constructor: (membership) ->
    super(membership)
    @org   = membership.org
    @user  = membership.user
    @level = membership.level

module.exports = MembershipModel
