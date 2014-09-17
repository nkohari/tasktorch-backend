exports.defined =
  (value) -> "Must be defined" unless value?

exports.notEmpty =
  (value) -> "Must not be an empty string" if value? and value.length == 0

exports.greaterThan = (min) ->
  (value) -> "Must be greater than #{min}" unless value > min

exports.lessThan = (max) ->
  (value) -> "Must be less than #{max}" unless value > max

exports.between = (min, max) ->
  (value) -> "Must be greater than #{min} and less than #{max}" unless min < value < max

exports.enum = (values...) ->
  (value) -> "Must be one of #{values.join(', ')}" unless values.indexOf(value) >= 0
