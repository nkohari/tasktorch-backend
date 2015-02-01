_    = require 'lodash'
Gate = require 'security/framework/Gate'

class OrgGate extends Gate

  guards: 'Org'

  getAccessList: (org, callback) ->
    callback null, _.clone(org.members)

module.exports = OrgGate
