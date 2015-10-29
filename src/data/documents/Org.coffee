_         = require 'lodash'
Document  = require 'data/framework/Document'
OrgStatus = require 'data/enums/OrgStatus'

class Org extends Document

  @table   'orgs'
  @naming  {singular: 'org', plural: 'orgs'}

  @field   'id'
  @field   'version'
  @field   'created'
  @field   'updated'
  @field   'status',  {default: OrgStatus.Normal}
  @field   'name'
  @field   'email'
  @field   'survey'
  @field   'billing', {default: null}

  @hasMany 'members',       {type: 'User', default: []}
  @hasMany 'leaders',       {type: 'User', default: []}
  @hasMany 'activeMembers', {type: 'User', default: []}

  hasLeader: (userid) ->
    _.contains(@leaders, userid)

  hasMember: (userid) ->
    _.contains(@members, userid)

module.exports = Org
