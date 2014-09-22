Hapi = require 'hapi'

class Controller

  error: (err) ->
    Hapi.error.internal('Something bad happened', err)

  notFound: ->
    Hapi.error.notFound()

  unauthorized: ->
    Hapi.error.unauthorized()

module.exports = Controller
