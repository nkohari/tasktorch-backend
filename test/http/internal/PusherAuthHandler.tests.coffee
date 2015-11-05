_                 = require 'lodash'
expect            = require('chai').expect
TestHarness       = require 'test/framework/TestHarness'
PusherAuthHandler = require 'apps/api/handlers/internal/PusherAuthHandler'

describe 'internal:PusherAuthHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(PusherAuthHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called to request access to a presence channel', ->

    channelFor = (orgid) -> "presence-org-#{orgid}"

    describe 'for a non-existent org', ->

      payload = {socket_id: '123.456', channel_name: channelFor('doesnotexist')}

      it 'returns 400 bad request', (done) ->
        @tester.request {payload}, (res) =>
          expect(res.statusCode).to.equal(400)
          done()

    describe 'for an org of which the requester is not a member', ->

      payload = {socket_id: '123.456', channel_name: channelFor('org-sudz')}

      it 'returns 403 forbidden', (done) ->
        @tester.request {payload}, (res) =>
          expect(res.statusCode).to.equal(403)
          done()

    describe 'for an org of which the requester is a member', ->

      payload = {socket_id: '123.456', channel_name: channelFor('org-paddys')}

      it 'returns a valid pusher token with presence data', (done) ->
        @tester.request {payload}, (res) =>
          expect(res.statusCode).to.equal(200)
          expect(res.result).to.exist
          expect(res.result.auth).to.exist
          expect(res.result.channel_data).to.exist
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called to request access to a user channel', ->

    channelFor = (userid) -> "private-user-#{userid}"

    describe 'for a non-existent user', ->

      payload = {socket_id: '123.456', channel_name: channelFor('doesnotexist')}

      it 'returns 400 bad request', (done) ->
        @tester.request {payload}, (res) =>
          expect(res.statusCode).to.equal(400)
          done()

    describe 'for a user who is not the requester', ->

      payload = {socket_id: '123.456', channel_name: channelFor('user-frank')}

      it 'returns 403 bad request', (done) ->
        @tester.request {payload}, (res) =>
          expect(res.statusCode).to.equal(403)
          done()

    describe 'for the requesting user', ->

      payload = {socket_id: '123.456', channel_name: channelFor('user-charlie')}

      it 'returns a valid pusher token', (done) ->
        @tester.request {payload}, (res) =>
          expect(res.statusCode).to.equal(200)
          expect(res.result).to.exist
          expect(res.result.auth).to.exist
          done()

#---------------------------------------------------------------------------------------------------
