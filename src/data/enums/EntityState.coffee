Enum = require 'common/util/enum'

EntityState = Enum [
  'ACTIVE',
  'DELETED',
  'DISABLED'
]

module.exports = EntityState
