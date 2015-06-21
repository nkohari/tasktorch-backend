_                = require 'lodash'
expect           = require('chai').expect
TestHarness      = require 'test/framework/TestHarness'
CommonBehaviors  = require 'test/framework/CommonBehaviors'
GetActionHandler = require 'apps/api/handlers/actions/GetActionHandler'

describe 'GetActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetActionHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', actionid: 'action-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', actionid: 'action-takedbaby', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', actionid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid action in an org of which the requester is a member', ->
    it 'returns the action', (done) ->
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action).to.exist()
        expect(action.id).to.equal('action-takedbaby')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', actionid: 'action-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and actionid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', actionid: 'action-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
