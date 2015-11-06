_                             = require 'lodash'
expect                        = require('chai').expect
TestHarness                   = require 'test/framework/TestHarness'
ChangeMembershipStatusHandler = require 'apps/api/handlers/memberships/ChangeMembershipStatusHandler'

describe 'memberships:ChangeMembershipStatusHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeMembershipStatusHandler, 'user-frank')
      ready()

  afterEach (done) ->
    TestHarness.reset ['memberships'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {status: 'Disabled'}

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, membershipid, payload, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid        = 'doesnotexist'
    membershipid = 'membership-paddys-charlie'
    payload      = {status: 'Disabled'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent membership', ->

    orgid        = 'org-paddys'
    membershipid = 'doesnotexist'
    payload      = {status: 'Disabled'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a status argument', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid status argument', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {status: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid status argument', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {status: 'Disabled'}

    it 'sets the membership status to the specified status and returns it', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {membership} = res.result
        expect(membership).to.exist
        expect(membership.id).to.equal(membershipid)
        expect(membership.status).to.equal(payload.status)
        done()

#---------------------------------------------------------------------------------------------------

  describe "when called for the requester's own membership", ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-frank'
    payload      = {status: 'Member'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member but not a leader', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-paddys-charlie'
    payload      = {status: 'Disabled'}
    credentials  = TestHarness.getCredentials('user-charlie')

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, membershipid, payload, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a mismatched org and membership', ->

    orgid        = 'org-paddys'
    membershipid = 'membership-sudz-greg'
    payload      = {status: 'Disabled'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid        = 'org-sudz'
    membershipid = 'membership-sudz-greg'
    payload      = {status: 'Disabled'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, membershipid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
