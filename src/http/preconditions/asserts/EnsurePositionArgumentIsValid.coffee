_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsurePositionArgumentIsValid extends Precondition

  execute: (request, reply) ->
    {position} = request.payload
    if not position? or _.isNumber(position) or position is 'append' or position is 'prepend'
      return reply()
    else
      return @error.badRequest("Invalid value specified for position argument")

module.exports = EnsurePositionArgumentIsValid
