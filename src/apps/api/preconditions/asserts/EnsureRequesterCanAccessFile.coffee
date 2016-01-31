_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessFile extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {file} = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess file, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access file #{file.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessFile
