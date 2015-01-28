Hapi = require 'hapi'
Boom = require 'boom'

class Precondition

  error: Boom

  execute: (request, reply) ->
    throw new Error("You must implement execute() on #{@constructor.name}")

module.exports = Precondition
