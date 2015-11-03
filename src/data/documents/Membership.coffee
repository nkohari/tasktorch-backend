_                = require 'lodash'
Document         = require 'data/framework/Document'
MembershipStatus = require 'data/enums/MembershipStatus'
MembershipLevel  = require 'data/enums/MembershipLevel'

class Membership extends Document

  @table   'memberships'
  @naming  {singular: 'membership', plural: 'memberships'}

  @field   'id'
  @field   'version'
  @field   'created'
  @field   'updated'
  @field   'status', {default: MembershipStatus.Normal}
  @field   'level',  {default: MembershipLevel.Member}

  @hasOne  'org',    {type: 'Org'}
  @hasOne  'user',   {type: 'User'}

module.exports = Membership
