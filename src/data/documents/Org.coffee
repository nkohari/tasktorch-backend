_              = require 'lodash'
Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Org extends Document

  @table   'orgs'
  @naming  {singular: 'org', plural: 'orgs'}

  @field   'id'
  @field   'version'
  @field   'status',  {default: DocumentStatus.Normal}
  @field   'name'

  @hasMany 'teams',   {type: 'Team'}
  @hasMany 'members', {type: 'User'}
  @hasMany 'leaders', {type: 'User'}

  hasLeader: (userid) ->
    _.contains(@leaders, userid)

  hasMember: (userid) ->
    _.contains(@members, userid)

module.exports = Org
