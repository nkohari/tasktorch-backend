Document   = require 'data/framework/Document'
FileStatus = require 'data/enums/FileStatus'

class File extends Document

  @table  'files'
  @naming {singular: 'file', plural: 'files'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status',       {default: FileStatus.Normal}
  @field  'name'
  @field  'key'
  @field  'size',         {default: null}
  @field  'type',         {default: null}
  @field  'hasThumbnail', {default: false}

  @hasOne 'org', {type: 'Org'}

module.exports = File
