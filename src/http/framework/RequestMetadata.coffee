class RequestMetadata

  constructor: (request) ->
    @user   = request.auth.credentials.user
    @org    = request.scope.org
    @socket = request.socket

module.exports = RequestMetadata
