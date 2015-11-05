_                = require 'lodash'
expect           = require('chai').expect
TestHarness      = require 'test/framework/TestHarness'
GetActionHandler = require 'apps/api/handlers/actions/GetActionHandler'

describe 'actions:GetActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetActionHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, actionid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid    = 'doesnotexist'
    actionid = 'action-takedbaby'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->

    orgid    = 'org-paddys'
    actionid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid action in an org of which the requester is a member', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'

    it 'returns the action', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action).to.exist
        expect(action.id).to.equal(actionid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid    = 'org-sudz'
    actionid = 'action-ringbell'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and actionid', ->

    orgid    = 'org-paddys'
    actionid = 'action-ringbell'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
