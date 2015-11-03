_      = require 'lodash'
expect = require('chai').expect

CommonBehaviors = {}

CommonBehaviors.requiresAuthentication = (options = {}) ->

  describe 'when called without credentials', ->
    it 'returns 401 unauthorized', (done) ->
      config = _.extend options, {credentials: false}
      @tester.request config, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

module.exports = CommonBehaviors
