_                    = require 'lodash'
expect               = require('chai').expect
TestHarness          = require 'test/framework/TestHarness'
GetMembershipHandler = require 'apps/api/handlers/memberships/GetMembershipHandler'

describe 'memberships:GetMembershipHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetMembershipHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, membershipid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid        = 'org-oldiesrockcafe'
    membershipid = 'membership-paddys-charlie'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, membershipid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid        = 'doesnotexist'
    membershipid = 'membership-paddys-charlie'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent membership', ->

    orgid        = 'org-paddys'
    membershipid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'

    it 'returns the membership', (done) ->
      @tester.request {orgid, membershipid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {membership} = res.result
        expect(membership).to.exist
        expect(membership.id).to.equal(membershipid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid        = 'org-sudz'
    membershipid = 'membership-sudz-greg'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, membershipid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
