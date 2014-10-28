class RequestMetadata

  constructor: (request) ->
    @user         = request.auth.credentials.user
    @organization = request.scope.organization
    @socket       = request.socket

module.exports = RequestMetadata
