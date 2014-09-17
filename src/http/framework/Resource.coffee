Hapi = require 'hapi'

class Resource

  error: (err) ->
    Hapi.error.internal('Something bad happened', err)

  notFound: ->
    Hapi.error.notFound()

module.exports = Resource
