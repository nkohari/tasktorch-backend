_                = require 'lodash'
expect           = require('chai').expect
TestHarness      = require 'test/framework/TestHarness'
GetInviteHandler = require 'apps/api/handlers/invites/GetInviteHandler'

describe 'invites:GetInviteHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetInviteHandler)
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent invite', ->

    inviteid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {inviteid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid invite', ->

    inviteid = 'invite-waitress'

    it 'returns the invite', (done) ->
      @tester.request {inviteid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {invite} = res.result
        expect(invite).to.exist
        expect(invite.id).to.equal(inviteid)
        done()

#---------------------------------------------------------------------------------------------------
