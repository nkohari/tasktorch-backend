_ = require 'lodash'

module.exports = arrayEnum = (values) ->
  _.object _.map values, (value) -> [value, value]
