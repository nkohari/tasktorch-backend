_              = require 'lodash'
Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Team extends Document

  @table  'teams'
  @naming {singular: 'team', plural: 'teams'}

  @field  'id'
  @field  'version'
  @field  'status',   {default: DocumentStatus.Normal}
  @field  'name'
  @field  'purpose',  {default: null}

  @hasOne  'org',     {type: 'Org'}
  @hasMany 'leaders', {type: 'User', default: []}
  @hasMany 'members', {type: 'User', default: []}

  @hasManyForeign 'stacks', {type: 'Stack', index: 'team'}

  hasLeader: (userid) ->
    _.contains(@leaders, userid)

  hasMember: (userid) ->
    _.contains(@members, userid)

module.exports = Team
