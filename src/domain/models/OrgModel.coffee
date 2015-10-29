Model = require 'domain/framework/Model'

class OrgModel extends Model

  constructor: (org) ->
    super(org)
    @name          = org.name
    @leaders       = org.leaders
    @members       = org.members
    @activeMembers = org.activeMembers
    @email         = org.email

module.exports = OrgModel
