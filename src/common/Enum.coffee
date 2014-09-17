_ = require 'lodash'

Enum = (keys) ->
  _.object _.map keys, (key) -> [key, key.toLowerCase()]

module.exports = Enum
