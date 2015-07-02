_           = require 'lodash'
Document    = require 'data/framework/Document'
TokenStatus = require 'data/enums/TokenStatus'

class Token extends Document

  @table  'tokens'
  @naming {singular: 'token', plural: 'tokens'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status',  {default: TokenStatus.Pending}
  @field  'email'
  @field  'comment', {default: null}

  @hasOne 'creator', {type: 'User', default: null}
  
module.exports = Token
