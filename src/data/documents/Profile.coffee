Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Profile extends Document

  @table  'profiles'
  @naming {singular: 'profile', plural: 'profiles'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status',   {default: DocumentStatus.Normal}
  @field  'title',    {default: null}
  @field  'bio',      {default: null}
  @field  'contacts', {default: []}

  @hasOne 'user',     {type: 'User'}
  @hasOne 'org',      {type: 'Org'}

module.exports = Profile
