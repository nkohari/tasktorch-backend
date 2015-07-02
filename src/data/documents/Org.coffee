_              = require 'lodash'
Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Org extends Document

  @table   'orgs'
  @naming  {singular: 'org', plural: 'orgs'}

  @field   'id'
  @field   'version'
  @field   'created'
  @field   'updated'
  @field   'status',  {default: DocumentStatus.Normal}
  @field   'name'
  @field   'survey'

  @hasMany 'members', {type: 'User', default: []}
  @hasMany 'leaders', {type: 'User', default: []}

  hasLeader: (userid) ->
    _.contains(@leaders, userid)

  hasMember: (userid) ->
    _.contains(@members, userid)

module.exports = Org
