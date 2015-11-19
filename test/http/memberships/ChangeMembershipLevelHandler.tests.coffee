_                            = require 'lodash'
expect                       = require('chai').expect
TestHarness                  = require 'test/framework/TestHarness'
ChangeMembershipLevelHandler = require 'apps/api/handlers/memberships/ChangeMembershipLevelHandler'

describe 'memberships:ChangeMembershipLevelHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMembershipLevelHandler, 'user-frank')
      ready()

  afterEach (done) ->
    TestHarness.reset ['memberships'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {level: 'Leader'}

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, membershipid, payload, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid        = 'org-oldiesrockcafe'
    membershipid = 'membership-paddys-charlie'
    payload      = {level: 'Leader'}

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid        = 'doesnotexist'
    membershipid = 'membership-paddys-charlie'
    payload      = {level: 'Leader'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent membership', ->

    orgid        = 'org-paddys'
    membershipid = 'doesnotexist'
    payload      = {level: 'Leader'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a level argument', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid level argument', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {level: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid level argument', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {level: 'Leader'}

    it 'sets the membership level to the specified level and returns it', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {membership} = res.result
        expect(membership).to.exist
        expect(membership.id).to.equal(membershipid)
        expect(membership.level).to.equal(payload.level)
        done()

#---------------------------------------------------------------------------------------------------

  describe "when called for the requester's own membership", ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-frank'
    payload      = {level: 'Member'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member but not a leader', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {level: 'Leader'}
    credentials  = TestHarness.getCredentials('user-charlie')

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, membershipid, payload, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a mismatched org and membership', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-sudz-greg'
    payload      = {level: 'Leader'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid        = 'org-sudz'
    membershipid = 'membership-sudz-greg'
    payload      = {level: 'Leader'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
