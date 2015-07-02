_            = require 'lodash'
Document     = require 'data/framework/Document'
InviteStatus = require 'data/enums/InviteStatus'

class Invite extends Document

  @table  'invites'
  @naming {singular: 'invite', plural: 'invites'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status',  {default: InviteStatus.Pending}
  @field  'email'
  @field  'leader'
  @field  'orgName'

  @hasOne 'creator', {type: 'User'}
  @hasOne 'org',     {type: 'Org'}

module.exports = Invite
