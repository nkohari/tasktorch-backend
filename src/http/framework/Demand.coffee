Hapi = require 'hapi'

class Demand

  error: Hapi.error

  execute: (request, reply) ->
    throw new Error("You must implement execute() on #{@constructor.name}")

module.exports = Demand
