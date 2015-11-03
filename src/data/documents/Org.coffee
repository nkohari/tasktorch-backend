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
  @field   'account', {default: null}

module.exports = Org
