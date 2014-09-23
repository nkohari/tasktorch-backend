Hapi = require 'hapi'

class Demand

  test: (request, reply) ->
    @satisfies request, (err, satisfied) =>
      return reply Hapi.error.internal('Something bad happened', err) if err?
      return reply Hapi.error.unauthorized() unless satisfied
      reply()

  satisfies: (request, callback) ->
    throw new Error("You must implement satisfies() on #{@constructor.name}")

module.exports = Demand
