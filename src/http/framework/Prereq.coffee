Hapi = require 'hapi'

class Prereq

  error: Hapi.error

  execute: (request, reply) ->
    throw new Error("You must implement execute() on #{@constructor.name}")

module.exports = Prereq
